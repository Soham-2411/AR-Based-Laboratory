import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:model_viewer/model_viewer.dart';

class ARModelDetails {
  final String image;
  final String link;
  final String title;

  ARModelDetails(this.image, this.link, this.title);
}

List<ARModelDetails> _arModelDetails = [
  ARModelDetails(
      'assets/BlocksLabEquipment.png',
      'https://storage.echo3d.co/rapid-flower-4578/34ec05f9-13e7-4c41-bcd0-b268aadf1b1c.glb',
      'Lab Equipments'),
  ARModelDetails(
      'assets/DNA.png',
      'https://storage.echo3d.co/rapid-flower-4578/7b50f257-b3e1-400a-aeed-e96a8eba9072.glb',
      'DNA Molecule'),
  ARModelDetails(
      'assets/Heart.png',
      'https://storage.echo3d.co/rapid-flower-4578/c7d2116f-8d6f-4d44-93fd-2c223156ecbf.glb',
      'Heart'),
  ARModelDetails(
      'assets/PendulumString.png',
      'https://storage.echo3d.co/rapid-flower-4578/512e0abe-92eb-4733-bca1-2d191756ed40.glb',
      'Pendulum'),
  ARModelDetails(
      'assets/Lungs.png',
      'https://storage.echo3d.co/rapid-flower-4578/ba7b2646-a27e-4bc6-8be8-deeddfa2a94b.glb',
      'Lungs'),
  ARModelDetails(
      'assets/Computer.png',
      'https://storage.echo3d.co/rapid-flower-4578/0a8e65fe-cf97-4e4c-b7f9-999622ef2545.glb',
      'Computer'),
  ARModelDetails(
      'assets/Beaker.png',
      'https://storage.echo3d.co/rapid-flower-4578/c5483603-cb85-4dd2-9ce1-7afac8f90a89.glb',
      'Beaker'),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "AR Laboratory Models",
                      style: TextStyle(
                          fontSize: width * 0.1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    for (int index = 0; index < _arModelDetails.length; index++)
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: HexColor("#261D32"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            child: SizedBox(
                                height: 150,
                                width: width - 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 45,
                                      backgroundImage: AssetImage(
                                          _arModelDetails[index].image),
                                    ),
                                    const SizedBox(
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
                          const SizedBox(
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
