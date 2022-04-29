import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'Pages/Navbar.dart';
import 'authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

SharedPreferences prefs;
int x, y, Timeduration;
String s = "";
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString('sa_email');
    if (email == null) email = '';
  } catch (e) {}
  runApp(ScholarAid());
}

class ScholarAid extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with WidgetsBindingObserver {
  @override
  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void initState() {
    // TODO: implement initState
    initPrefs();
    print(DateTime.now());
    s = DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString();
    y = prefs.getInt(s) ?? 0;
    print(y);
    x = 60 * DateTime.now().hour.toInt() + DateTime.now().minute.toInt();
    print(s);
    print(x);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeDependencies

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      //print('paused');
      prefs.setInt(
          s,
          60 * DateTime.now().hour.toInt() +
              DateTime.now().minute.toInt() -
              x +
              y);
      print(60 * DateTime.now().hour.toInt() +
          DateTime.now().minute.toInt() -
          x +
          y);
    }
    // else if(state==AppLifecycleState.inactive){
    //   print('inactive');
    // }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    Timer(Duration(seconds: 3), () {
      if (email == '') {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: Authentication(),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 625)));
      } else {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: NavBar(),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 625)));
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ScholarAid',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: w / 10,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: h / 10,
            ),
            Text(
              'Hackofiesta 2021 Submission',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: w / 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: h / 6,
            ),
            Image.asset('assets/loading.gif'),
            Text(
              '~  Ctrl  ~  Alt  ~  Elite  ~',
              style: TextStyle(
                  color: Color(0xffdbddfa),
                  fontSize: w / 32.7272,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Presents',
              style: TextStyle(
                  color: Color(0xffdbddfa),
                  fontSize: w / 32.7272,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
