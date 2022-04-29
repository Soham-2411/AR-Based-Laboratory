import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scholar_aid/Pages/Navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/One_on_One_Chat/database1.dart';
import 'main.dart';

String select = "Student";
String email = '';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  CollectionReference userRefrence =
      FirebaseFirestore.instance.collection('Users');
  String password = '';
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);
  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        //cursorColor: Colors.deepPurple,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            /*Container(
              height: h/1.2,
              width: w,
              child: RotatedBox(
                quarterTurns: 0,
                child: FlareActor(
                  'assets/flow drawer.flr',
                  animation: 'Flow',
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.fill,
                ),
              ),
            ),*/
            FlutterLogin(
              title: '',
              emailValidator: (value) {
                if (!value.contains('@') || !value.endsWith('.com')) {
                  return "Email must contain '@' and end with '.com'";
                }
                return null;
              },
              passwordValidator: (value) {
                if (value.isEmpty) {
                  return 'Password is empty';
                }
                return null;
              },
              onLogin: (loginData) async {
                email = loginData.name;
                password = loginData.password;
                try {
                  final prefs = await SharedPreferences.getInstance();
                  UserCredential newUser = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  userRefrence
                      .doc(email.substring(0, email.indexOf('@')))
                      .get()
                      .then((DocumentSnapshot documentSnapshot) {
                    if (documentSnapshot.exists) {
                      //  CircleAvtarImage=link.toString();
                      prefs.setString('sa_email', email);
                      main();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NavBar()));
                    } else {
                      print('unsuccessful');
                    }
                  });
                } catch (e) {
                  print(e);
                }
                return _loginUser(loginData);
              },
              onSignup: (loginData) async {
                email = loginData.name;
                password = loginData.password;
                try {
                  final newUser = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  Map<String, String> userDataMap = {
                    "userName":
                        loginData.name.substring(0, loginData.name.length - 10),
                    "userEmail": loginData.name,
                  };
                  DatabaseMethods databaseMethods = new DatabaseMethods();
                  databaseMethods.addUserInfo(userDataMap);
                  userRefrence
                      .doc(email.substring(0, email.indexOf('@')))
                      .set({
                        'Email': email,
                      })
                      .then((value) => print('user Added'))
                      .catchError((error) => print('Failed to add'));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Authentication()));
                } catch (e) {
                  print(e);
                }
                return _loginUser(loginData);
              },
              onRecoverPassword: (email) {
                //reset pw of email
                return _recoverPassword(email);
              },
            ),
            Container(
              margin: EdgeInsets.only(top: w / 4, left: w / 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hey",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'Fredoka One',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4),
                  ),
                  Text(
                    "Folks !!!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'Fredoka One',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
