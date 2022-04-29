import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scholar_aid/Pages/Navbar.dart';

class AI extends StatefulWidget {
  @override
  _AIState createState() => _AIState();
}

var questions = [];
var correct = [];
var answers = [];
var para = '';
class _AIState extends State<AI> {

  @override
  void initState() {
    status = 'para';
    summary = '';
    para = '';
    questions = [];
    correct = [];
    answers = [];
    // TODO: implement initState
    super.initState();
  }
  var status = 'para';
  var summary = '';

  generateSummary(String doc) async {
    EasyLoading.show(status: 'loading...');
    var url = 'http://localhost:7000/?' + 'passage=' + doc;

    try {
      print('calling');
      Response response = await http.get(url);
      print('called');
      dom.Document document = parser.parse(response.body);
      setState(() {
        summary = document.getElementsByTagName('h1')[0].innerHtml;
      });
      setState(() {
        status = 'sum';
      });
    } catch (e) {}
    EasyLoading.dismiss();
  }

  generateQuestions(String doc) async {
    EasyLoading.show(status: 'loading...');
    var url = 'http://localhost:5000/?' + 'text=' + doc;

    try {
      print('calling');
      Response response = await http.get(url);
      print('called');
      dom.Document document = parser.parse(response.body);
      setState(() {
        for(var q in document.getElementsByTagName('h1')) {
          questions.add(q.innerHtml);
        }
        for(var q in document.getElementsByTagName('h2')) {
          correct.add(q.innerHtml);
          answers.add('');
        }
      });
      setState(() {
        status = 'test';
      });
    } catch (e) {}
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'ParaQueries',
              style: TextStyle(
                  fontSize: width * 0.1,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff261D32),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: status == 'para' ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '    Powered by AI',
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                height: 40,
                                width: 4,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                  'Provide Us With Some Docs...',
                                style: TextStyle(
                                    color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  fontSize:18
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            minLines: 8,
                            maxLines: 16,
                            style: TextStyle(
                                color: Colors.grey
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter ~ Here',
                              hintStyle: TextStyle(
                                  color: Color(0xffdbddfa)
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              para = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff5B04BC)) ),
                                child: Text(
                                  'Generate Summary',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2
                                  ),
                                ),
                                onPressed: () {
                                  if(para != '')
                                    generateSummary(para);
                                },
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff5B04BC)) ),
                                child: Text(
                                  'Take a Test',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2
                                  ),
                                ),
                                onPressed: () {
                                  if(para != '')
                                    generateQuestions(para);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ) : status == 'sum' ? Container(
                      //height: height/1.5,
                      width: width/1.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '    Powered by AI',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                                'Summary',
                              style: TextStyle(
                                  fontSize: width * 0.08,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.all(24.0),
                            child: SingleChildScrollView(
                              child: Text(
                                summary,
                                style: TextStyle(
                                    color: Color(0xffdbddfa)
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff5B04BC)) ),
                              child: Text(
                                'Back',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  status = 'para';
                                  summary = '';
                                  para = '';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ) : status == 'test' ? Container(
                      //height: height/1.5,
                      width: width/1.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '    Powered by AI',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              'Test',
                              style: TextStyle(
                                  fontSize: width * 0.08,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.all(24.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for(int i = 0;i < questions.length; i++)
                                    ListTile(
                                      title: Text(
                                          questions[i],
                                        style: TextStyle(
                                            fontSize: width * 0.05,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.only(bottom: 12, left: 8),
                                        child: TextField(
                                          style: TextStyle(
                                              color: Colors.grey
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Your Answer..',
                                            hintStyle: TextStyle(
                                                color: Color(0xffdbddfa)
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            answers[i] = value;
                                          },
                                        ),
                                      ),
                                    )
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff5B04BC)) ),
                                  child: Text(
                                    'Back',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      status = 'para';
                                      para = '';
                                      questions = [];
                                      correct = [];
                                      answers = [];
                                    });
                                  },
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff5B04BC)) ),
                                  child: Text(
                                    'Marks',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2
                                    ),
                                  ),
                                  onPressed: () {
                                    //users answer
                                    print(answers);
                                    //correct answer
                                    print(correct);
                                    setState(() {
                                      status = 'para';
                                    });
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: PieChartPage(),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 625)));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ) : Container(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int correctAns = 0;
int wrongAns = questions.length;

class PieData {
  static List<Data> data = [];
}

class Data {
  final String name;

  final double percent;

  final Color color;

  Data({this.name, this.percent, this.color});
}

class PieChartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartPageState();
}

class PieChartPageState extends State {
  int touchedIndex;

  @override
  void initState() {
    for (int i = 0; i < questions.length; i++){
      if(correct[i].toString().toLowerCase() == answers[i].toString().toLowerCase())
        correctAns++;
    }
    wrongAns = wrongAns - correctAns;
    PieData.data = [Data(name: 'Right Answers', percent: correctAns/questions.length * 100, color: Color(0xff5B04BC)), Data(name: 'Wrong Answers', percent: wrongAns/questions.length * 100, color: Color(0xffdbddfa))];
    setState(() {});
    Timer(Duration(seconds: 1), () {
      questions = [];
      correct = [];
      answers = [];
      para = '';
      correctAns = 0;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: HexColor('#1A1125'),
    body: Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
          painter: CurvePainter(),
        ),
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 54,
              ),
              Text(
                'Mark Sheet',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Total Questions ~ ' + questions.length.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Total Correct Answers ~ ' + correctAns.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Total Wrong Answers ~ ' + wrongAns.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  Text(
                    'Percentage of Course Learnt ~ ' + (correctAns/questions.length * 100).toString() + ' %',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        'Result ~ ',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2
                        ),
                      ),
                      correctAns/questions.length * 100 >= 80 ? Text(
                        'Passed',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2
                        ),
                      ) : correctAns/questions.length * 100 >= 50 ? Text(
                        'Promoted',
                        style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2
                        ),
                      ) : Text(
                        'Failed',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: getSections(touchedIndex),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: IndicatorsWidget(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class IndicatorsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: PieData.data
        .map(
          (data) => Container(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: buildIndicator(
            color: data.color,
            text: data.name,
            // isSquare: true,
          )),
    )
        .toList(),
  );

  Widget buildIndicator({
    @required Color color,
    @required String text,
    bool isSquare = false,
    double size = 16,
    Color textColor = const Color(0xff505050),
  }) =>
      Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      );
}

List<PieChartSectionData> getSections(int touchedIndex) => PieData.data
    .asMap()
    .map<int, PieChartSectionData>((index, data) {
  final isTouched = index == touchedIndex;
  final double fontSize = isTouched ? 25 : 16;
  final double radius = isTouched ? 100 : 80;

  final value = PieChartSectionData(
    color: data.color,
    value: data.percent,
    title: '${data.percent}%',
    radius: radius,
    titleStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: const Color(0xffffffff),
    ),
  );

  return MapEntry(index, value);
})
    .values
    .toList();
