import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholar_aid/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:scholar_aid/main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

String teacherNumber = ' ';
String parentNumber = ' ';

Future<void> _setData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('Teacher Number', teacherNumber);
  prefs.setString('Parent Number', parentNumber);
}

Future<String> getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('Teacher Number') != null) {
    teacherNumber = prefs.getString('Teacher Number');
  }
  if (prefs.getString('Parent Number') != null) {
    parentNumber = prefs.getString('Parent Number');
  }
  if (parentNumber.length != 0 && teacherNumber.length != 0) {
    return parentNumber + teacherNumber;
  }
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;
  final picker = ImagePicker();
  String CircleAvtarLink = null;
  CollectionReference UserRefrance =
      FirebaseFirestore.instance.collection('ProfilePicUrl');

  Future<void> AddToFirestore(var url) {
    return UserRefrance.doc(email.substring(0, email.indexOf('@')))
        .set({
          'URL': url,
        })
        .then((value) => print('user added'))
        .catchError((error) => print('Failed to add User'));
  }

  Future<StorageUploadTask> uploadFile(BuildContext context) async {
    String fileName = path.basename(_image.path);
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(email.substring(0, email.indexOf('@')))
        .child(fileName);
    StorageUploadTask uploadTask = ref.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final url1 = await taskSnapshot.ref.getDownloadURL();
    //print(url1.toString());
    setState(() {
      CircleAvtarLink = url1.toString();
      AddToFirestore(url1);
    });
  }

  Future<void> getImageViaGallery() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper.cropImage(
        sourcePath: File(pickedFile.path).path,
      );
      setState(() {
        if (croppedFile != null) {
          _image = File(croppedFile.path);
          uploadFile(context);
        } else {
          print('No file selected');
        }
      });
    }
  }

  Future<void> getImageViaCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper.cropImage(
        sourcePath: File(pickedFile.path).path,
      );
      setState(() {
        if (croppedFile != null) {
          _image = File(croppedFile.path);
          uploadFile(context);
        } else {
          print('No file selected');
        }
      });
    } else {
      print('No file selected');
    }
  }

  String setImage() {
    String mainLink = null;
    UserRefrance.doc(email.substring(0, email.indexOf('@')))
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var link = documentSnapshot.data()['URL'];
        print(link);
        setState(() {
          CircleAvtarLink = link.toString();
        });
        //  CircleAvtarImage=link.toString();
        print(CircleAvtarLink);
      } else {
        print('unsucsessful');
      }
    });
  }

  void displayBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                    onTap: getImageViaCamera,
                  ),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: Text('Gallery'),
                    onTap: getImageViaGallery,
                  )
                ],
              ),
            ),
          );
        });
  }

  void initState() {
    super.initState();
    setImage();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20, top: 10),
                child: IconButton(
                  icon: Icon(
                    FlutterIcons.logout_ant,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('stud_bud_email');
                    prefs.remove('student_tutor');
                    main();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authentication()));
                  },
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height * 0.08),
                  child: TextButton(
                    onPressed: displayBottomSheet,
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        elevation: 10,
                        shape: CircleBorder()),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: CircleAvtarLink == null
                          ? NetworkImage(
                              'https://raw.githubusercontent.com/ParthPandey2236/Portfolio/master/images/profile.png')
                          : NetworkImage(CircleAvtarLink),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  email.substring(0, email.lastIndexOf('@')),
                  style: TextStyle(
                      fontSize: width * 0.06,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Container(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: HexColor('#1D1D1D')),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: teacherNumber,
                  onChanged: (value) {
                    setState(() {
                      teacherNumber = value;
                      _setData();
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      labelText: "Teacher's Number"),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Container(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: HexColor('#1D1D1D')),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: parentNumber,
                  onChanged: (value) {
                    setState(() {
                      parentNumber = value;
                      _setData();
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                      labelText: "Parent's Number"),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
