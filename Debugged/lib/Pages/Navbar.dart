import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:scholar_aid/Pages/ArtiIntel.dart';
import 'package:scholar_aid/Pages/Comm.dart';
import 'package:scholar_aid/Pages/One_on_One_Chat/ChatRoom.dart';
import 'package:scholar_aid/Pages/Profile.dart';

import 'AR.dart';
import 'ChatPage.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

int index = 0;

class _NavBarState extends State<NavBar> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: HexColor('#1A1125'),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: CurvePainter(),
              ),
              Container(
                  width: width,
                  height: height,
                  child: (index == 0)
                      ? ARModels()
                      : (index == 1)
                          ? AI()
                          : (index == 2)
                              ? CommSelectScreen()
                              : (index == 3)
                                  ? TutorsList()
                                  : ProfilePage())
            ],
          ),
        ),
      ),
      floatingActionButton: FabCircularMenu(
        animationCurve: Curves.easeInOutQuint,
        fabCloseColor: HexColor('#5B04BC'),
        key: fabKey,
        fabColor: HexColor('#5B04BC'),
        ringColor: Colors.transparent,
        //animationDuration: const Duration(microseconds: 400),
        alignment: Alignment.bottomRight,
        fabOpenIcon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        fabCloseIcon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: HexColor('#5B04BC'),
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder()),
              child: Icon(
                FlutterIcons.laptop_ant,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () {
                setState(() {
                  index = 0;
                });
                if (fabKey.currentState.isOpen) {
                  fabKey.currentState.close();
                }
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: HexColor('#5B04BC'),
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder()),
              child: Icon(
                FlutterIcons.robot_mco,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () {
                setState(() {
                  index = 1;
                });
                if (fabKey.currentState.isOpen) {
                  fabKey.currentState.close();
                }
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: HexColor('#5B04BC'),
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder()),
              child: Icon(
                FlutterIcons.mobile1_ant,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () {
                setState(() {
                  index = 2;
                });
                if (fabKey.currentState.isOpen) {
                  fabKey.currentState.close();
                }
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: HexColor('#5B04BC'),
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder()),
              child: Icon(
                Icons.chat,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () {
                setState(() {
                  index = 3;
                });
                if (fabKey.currentState.isOpen) {
                  fabKey.currentState.close();
                }
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: HexColor('#5B04BC'),
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder()),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () {
                setState(() {
                  index = 4;
                });
                if (fabKey.currentState.isOpen) {
                  fabKey.currentState.close();
                }
              }),
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = HexColor('#6F01EC');
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.35, size.height * 0.65, size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
