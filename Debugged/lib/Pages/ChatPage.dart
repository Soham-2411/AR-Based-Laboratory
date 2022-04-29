import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:scholar_aid/src/pages/index.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'One_on_One_Chat/ChatRoom.dart';

class TutorsList extends StatefulWidget {
  @override
  TutorsListState createState() => TutorsListState();
}

final _firestore = FirebaseFirestore.instance;
List<TutorCards> tutorCards = [];

class TutorsListState extends State<TutorsList> {
  @override
  void initState() {
    // TODO: implement initState
    tutorCards = [
      new TutorCards(
        name: 'Dr. P.Madhavan',
        subject: 'Computer Communication',
        email: 'pmadhavan@srmist.edu.in',
        hourlyrate: 'Rs 500/hr',
        phoneno: '95166816548',
      ),
      new TutorCards(
          name: 'Selvinpaulpeter J',
          subject: 'Chemistry',
          email: 'selvinp@srmist.edu.in',
          hourlyrate: 'Rs 500/hr',
          phoneno: '951668165488'),
      new TutorCards(
          name: 'Boomakumari',
          subject: 'Lingustics',
          email: 'boomakumari@srmist.edu.in',
          hourlyrate: 'Rs 500/hr',
          phoneno: '95166816546')
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width - 150,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "List of Tutors",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.08,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IndexPage()));
                        },
                        icon: Icon(
                          FlutterIcons.video_call_mdi,
                          size: width * 0.07,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom()));
                        },
                        icon: Icon(
                          FlutterIcons.chat_outline_mco,
                          size: width * 0.07,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('Users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final cards = snapshot.data.docs.reversed;
                print(tutorCards);
                return Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 2.0),
                          children: tutorCards,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TutorCards extends StatefulWidget {
  String name, email, phoneno, subject, hourlyrate;
  TutorCards(
      {this.name, this.hourlyrate, this.subject, this.phoneno, this.email});
  @override
  TutorCardsState createState() => TutorCardsState();
}

class TutorCardsState extends State<TutorCards> {
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_RyfDbq015IzSkf',
      'amount': 50000,
      'name': 'ScholarAid',
      'description': 'Payment',
      'prefill': {'contact': '', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
        color: HexColor('#261D32'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        elevation: 8,
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          padding: EdgeInsets.only(left: 5, top: 5, bottom: 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 15, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.w500)),
                        Text(widget.hourlyrate,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.subject,
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Icon(
                              Icons.email,
                              size: width * 0.045,
                              color: Colors.grey[300],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(widget.email,
                                style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w500)),
                          ]),
                          Text(widget.phoneno,
                              style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w500)),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: openCheckout,
                    child: Text(
                      "Pay",
                      style: TextStyle(
                          fontSize: width * 0.04, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
