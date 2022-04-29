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
      'assets/Images/Bulb.png',
      'https://storage.echoar.xyz/raspy-thunder-0385/3f21dcfe-0427-4eb0-bb89-60262ba3f935.glb',
      'Electric Generator(A)'),
  ARModelDetails(
      'assets/Images/BLE.png',
      'https://storage.echoar.xyz/raspy-thunder-0385/44faa8a4-09df-419f-9a24-5b9fa9fc6930.glb',
      'Lab Equipment'),
  ARModelDetails(
      'assets/Images/Lungs.png',
      'https://storage.echoar.xyz/raspy-thunder-0385/f0eebfe3-8494-4171-bc9e-354b4bd6033e.glb',
      'Lungs Expanded'),
  ARModelDetails(
      'assets/Images/Heart.png',
      'https://storage.echoar.xyz/raspy-thunder-0385/96d25b23-c8f8-4a08-a795-a1110cfd3981.glb',
      'Heart'),
  ARModelDetails(
      'assets/Images/DNA.png',
      'https://storage.echoar.xyz/raspy-thunder-0385/478beacb-0d0d-45a1-8c65-9fe4b7092954.glb',
      'DNA'),
  ARModelDetails(
      'assets/Images/Computer.png',
      'https://storage.echoar.xyz/raspy-thunder-0385/4d4f623c-b671-4bb3-ad4f-e9b4e4806ed0.glb',
      'Computer'),
  ARModelDetails(
      'assets/Images/Testosterone.png',
      'https://storage.echoar.xyz/raspy-thunder-0385/339b3968-4f86-4714-94e6-8fd0607a2a14.glb',
      'Testosterone'),
  ARModelDetails(
      'assets/Images/Brain.png',
      'https://storage.echoar.xyz/raspy-thunder-0385/005f1d2c-e071-4ebb-a04c-dd8ea44c14f0.glb',
      'Brain'),
  ARModelDetails(
      'assets/Images/PendulumString.png',
      'https://storage.echoar.xyz/raspy-thunder-0385/4bcb4574-1c63-4c18-a557-3932d5b7fb76.glb',
      'Pendulum'),
  ARModelDetails(
      'assets/Images/Beaker.png',
      'https://storage.echoar.xyz/raspy-thunder-0385/13022b40-36b6-4f33-b205-80f7c34b9bee.glb',
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
    return Align(
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
                            CircleAvatar(
                              radius: 45,
                              backgroundImage:
                                  AssetImage(_arModelDetails[index].image),
                            ),
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
