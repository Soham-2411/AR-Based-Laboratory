import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:all_sensors/all_sensors.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_otp/flutter_otp.dart';
import 'package:scholar_aid/Pages/Profile.dart';

import '../main.dart';

class CommSelectScreen extends StatefulWidget {
  @override
  _CommSelectScreenState createState() => _CommSelectScreenState();
}

int page = 0;
final controller = PageController(initialPage: page, keepPage: false);

class _CommSelectScreenState extends State<CommSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        controller: controller,
        children: [
          PhoneUsed(),
          Communication(),
        ],
      ),
    );
  }
}

// INTEGER TO DISPLAY TIME
int _appTime = 69;

// WIDGET TO DISPLAY APP TIME
class PhoneUsed extends StatefulWidget {
  @override
  _PhoneUsedState createState() => _PhoneUsedState();
}

class _PhoneUsedState extends State<PhoneUsed> {
  String CurrentDate = 'today';

  @override
  void initState() {
    // TODO: implement initState
    prefs.setInt(
        s,
        60 * DateTime.now().hour.toInt() +
            DateTime.now().minute.toInt() -
            x +
            y);
    y = 60 * DateTime.now().hour.toInt() +
        DateTime.now().minute.toInt() -
        x +
        y;
    x = 60 * DateTime.now().hour.toInt() + DateTime.now().minute.toInt();
    setState(() {
      _appTime = prefs.getInt(s);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          SizedBox(height: height * 0.1),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 10,
                primary: HexColor("#261D32"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            child: Container(
                height: 80,
                width: width - 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Flip and Focus",
                      style: TextStyle(
                        fontSize: width * 0.05,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white.withAlpha(50),
                        ),
                      ),
                    ),
                  ],
                )),
            onPressed: () {
              controller.animateToPage(1,
                  duration: Duration(milliseconds: 500), curve: Curves.easeIn);
            },
          ),
          SizedBox(height: 50),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            elevation: 20,
            color: HexColor('#261D32'),
            child: Container(
              width: width - 50,
              height: height * 0.25,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'App Used',
                          style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            prefs.setInt(
                                s,
                                60 * DateTime.now().hour.toInt() +
                                    DateTime.now().minute.toInt() -
                                    x +
                                    y);
                            y = 60 * DateTime.now().hour.toInt() +
                                DateTime.now().minute.toInt() -
                                x +
                                y;
                            x = 60 * DateTime.now().hour.toInt() +
                                DateTime.now().minute.toInt();
                            //
                            print(y);
                            final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2011),
                                lastDate: DateTime(2031));
                            if (picked != null) {
                              print(picked.year.toString() +
                                  '-' +
                                  picked.month.toString() +
                                  '-' +
                                  picked.day.toString());
                              setState(() {
                                _appTime = prefs.getInt(picked.year.toString() +
                                        '-' +
                                        picked.month.toString() +
                                        '-' +
                                        picked.day.toString()) ??
                                    0;
                                CurrentDate = picked.day.toString() +
                                    '-' +
                                    picked.month.toString() +
                                    '-' +
                                    picked.year.toString();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "App use for ${CurrentDate}: \n\n",
                              style: TextStyle(
                                  fontSize: width * 0.06,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white)),
                          TextSpan(
                              text: _appTime.toString() + ' Mins',
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white))
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Communication extends StatefulWidget {
  @override
  _CommunicationState createState() => _CommunicationState();
}

bool proximityValues = false;

class _CommunicationState extends State<Communication> {
  CountDownController _controller = CountDownController();
  int _duration = 3600;
  bool proximityValues = false;
  bool flag = true;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(proximityEvents.listen((ProximityEvent event) {
      setState(() {
        proximityValues = event.getValue();
      });
    }));
  }

  FlutterOtp otp = FlutterOtp();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Center(
          child: Column(
        children: [
          CircularCountDownTimer(
            duration: _duration,
            initialDuration: 0,
            controller: _controller,
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,

            // Ring Color for Countdown Widget.
            ringColor: HexColor('#1A1125'),

            // Ring Gradient for Countdown Widget.
            ringGradient: null,

            // Filling Color for Countdown Widget.
            fillColor: Colors.purple,

            // Filling Gradient for Countdown Widget.
            fillGradient: null,

            // Background Color for Countdown Widget.
            backgroundColor: Colors.transparent,

            // Background Gradient for Countdown Widget.
            backgroundGradient: null,

            // Border Thickness of the Countdown Ring.
            strokeWidth: 20.0,

            // Begin and end contours with a flat edge and no extension.
            strokeCap: StrokeCap.round,

            // Text Style for Countdown Text.
            textStyle: TextStyle(
                fontSize: 33.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),

            // Format for the Countdown Text.
            textFormat: CountdownTextFormat.HH_MM_SS,

            // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
            isReverse: false,

            // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
            isReverseAnimation: false,

            // Handles visibility of the Countdown Text.
            isTimerTextShown: true,

            // Handles the timer start.
            autoStart: false,

            // This Callback will execute when the Countdown Starts.
            onStart: () {
              // Here, do whatever you want
              print('Countdown Started');
            },

            // This Callback will execute when the Countdown Ends.
            onComplete: () {
              // Here, do whatever you want
              print('Countdown Ended');
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: HexColor('#6F01EC'),
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                    child: Container(
                        width: width / 3 + 20,
                        height: 60,
                        child: Center(
                            child: Text(
                          "Start Session",
                          style: TextStyle(fontSize: width * 0.045),
                        ))),
                    onPressed: () {
                      Timer(
                        Duration(seconds: 1),
                        () {
                          if (proximityValues == true) {
                            Timer.periodic(Duration(milliseconds: 1), (timer) {
                              if (proximityValues == false) {
                                _controller.pause();
                                flag = true;
                              } else if (flag == true &&
                                  proximityValues == true) {
                                _controller.resume();
                                flag = false;
                              }
                            });
                            _controller.start();
                          }
                        },
                      );
                    }),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.transparent,
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                    child: Container(
                        width: width / 3 + 20,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: HexColor('5B04BC'))),
                        child: Center(
                            child: Text(
                          "End Session",
                          style: TextStyle(fontSize: width * 0.045),
                        ))),
                    onPressed: () {
                      print(_controller.getTime());
                      String time = _controller.getTime();
                       otp.sendOtp('${teacherNumber}', 'Your student has not used the phone and studied for $time since the start of the session.', 1000,
                           6000, "+91");
                       otp.sendOtp('${parentNumber}', 'Your child has not used the phone and studied for $time since the start of the session.', 1000,
                           6000, "+91");
                      _controller.restart(duration: _duration);
                    })
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 10,
                primary: HexColor("#261D32"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            child: Container(
                height: 80,
                width: width - 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Phone Used",
                      style: TextStyle(
                        fontSize: width * 0.05,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.white.withAlpha(50),
                        ),
                      ),
                    ),
                  ],
                )),
            onPressed: () {
              controller.animateToPage(0,
                  duration: Duration(milliseconds: 500), curve: Curves.easeIn);
            },
          ),
        ],
      )),
    );
  }
}

