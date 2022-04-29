import 'package:hexcolor/hexcolor.dart';

import '../../authentication.dart';
import '../Navbar.dart';
import 'constants.dart';
import 'database1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OChat.dart';
import 'search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

String currentUser;

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ChatRoomsTile(
                        userName: snapshot.data.documents[index]
                            .data()['chatRoomId']
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, ""),
                        chatRoomId:
                            snapshot.data.documents[index].data()["chatRoomId"],
                      );
                    }),
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    GstringUser();
    super.initState();
  }

  GstringUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUser = email;
  }

  getUserInfogetChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: HexColor('#1A1125'),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: CurvePainter(),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.08),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'CHAT',
                style: TextStyle(
                    letterSpacing: 1.3,
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.1),
            child: Container(
              child: chatRoomsList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            padding: EdgeInsets.all(0),
            primary: HexColor('#261D32'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        chatRoomId: chatRoomId,
                      )));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 80,
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: HexColor('#5B04BC'),
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(userName.substring(0, 1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(userName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w400))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.grey[500],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
