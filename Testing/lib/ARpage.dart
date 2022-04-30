import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:model_viewer/model_viewer.dart';

class ARModelDetails {
  final String link;
  final String title;

  ARModelDetails(this.link, this.title);
}

List<ARModelDetails> _arModelDetails = [
  ARModelDetails(
      'https://storage.echo3d.co/raspy-thunder-0385/a09a6d34-39c6-4810-8dfe-d9025e15abb1.glb',
      'DNA Model'),
  ARModelDetails(
      'https://storage.echoar.xyz/raspy-thunder-0385/44faa8a4-09df-419f-9a24-5b9fa9fc6930.glb',
      'Lab Equipment'),
  ARModelDetails(
      'https://storage.echoar.xyz/raspy-thunder-0385/f0eebfe3-8494-4171-bc9e-354b4bd6033e.glb',
      'Lungs Expanded'),
];

class ARModels extends StatefulWidget {
  @override
  _ARModelsState createState() => _ARModelsState();
}

class _ARModelsState extends State<ARModels> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#1A1125'),
        body: Stack(
          children: [
            CustomPaint(
              size: Size(width, height),
              painter: CurvePainter(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "AR Models",
                      style: TextStyle(
                          fontSize: width * 0.1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    for (int index = 0; index < _arModelDetails.length; index++)
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: HexColor("#261D32"),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            child: Container(
                                height: 150,
                                width: width - 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      _arModelDetails[index].title,
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Models(
                                            src: _arModelDetails[index].link,
                                          )));
                            },
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Models extends StatefulWidget {
  final String src;

  const Models({super.key, required this.src});

  @override
  _ModelsState createState() => _ModelsState();
}

class _ModelsState extends State<Models> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("AR Model"))),
      body: ModelViewer(
        backgroundColor: Colors.white,
        src: widget.src,
        alt: "3D Models",
        ar: true,
        autoRotate: true,
        cameraControls: true,
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
