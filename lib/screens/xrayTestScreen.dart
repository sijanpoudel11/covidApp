import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class XrayTestScreen extends StatefulWidget {
  const XrayTestScreen({Key? key}) : super(key: key);

  @override
  State<XrayTestScreen> createState() => _XrayTestScreenState();
}

class _XrayTestScreenState extends State<XrayTestScreen> {
  bool _loading = true;
  File? _image;
  Position? myPosition;
  List? _output;
  final picker = ImagePicker();
  Future<Position> getPosition() async {
    LocationPermission? permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        return Future.error('permission denied');
      }
    }
    print(await Geolocator.getCurrentPosition());
    return await Geolocator.getCurrentPosition();
  }

  double degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  int calculateDistance(LatLng location1, LatLng location2) {
    var earthRadiusKm = 6371;
    var dLat = degreesToRadians(location2.latitude - location1.latitude);
    var dLong = degreesToRadians(location2.longitude - location1.longitude);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(location2.latitude)) *
            cos(degreesToRadians(location1.latitude)) *
            sin(dLong / 2) *
            sin(dLong / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = (earthRadiusKm * c).toInt();

    print(d);
    return d;
  }

  void calculateAllDistance() {
    var distance;
    coOrdinates[0].forEach((element) {
      for (var i = 0; i < element.length; i++) {
        distance = calculateDistance(
            element[1], LatLng(myPosition!.latitude, myPosition!.longitude));
      }
      // element.add(distance);
      setState(() {
        element.add(distance);
      });
    });
    print(coOrdinates);
  }

  List<List> coOrdinates = [
    [
      [
        "bir hospital",
        LatLng(45.513218227614125, 9.21072419732809),
      ],
      [
        'Patan hospital',
        LatLng(45.51374449740213, 9.212186001241207),
      ],
      [
        'medicity hospital',
        LatLng(45.51474449740213, 9.213186001241207),
      ],
      [
        'sahid memorial hospital',
        LatLng(45.51375549740213, 9.212186001241207),
      ],
      [
        'green city hospital',
        LatLng(45.51974449740213, 9.222186001241207),
      ],
      [
        'star hospital',
        LatLng(45.51174449740213, 9.215186001241207),
      ],
      [
        'Teaching hospital',
        LatLng(45.51574449740213, 9.212181001241207),
      ],
      [
        'teku hospital',
        LatLng(45.561374449740213, 9.212112001241207),
      ],
      [
        'teku hospital',
        LatLng(46.561374449740213, 9.212112001241207),
      ],
    ]
  ];
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
        // pass
      });
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    myPosition = await getPosition();
    print(coOrdinates);
    calculateAllDistance();
    bubbleSort(coOrdinates[0]);
    print(coOrdinates);
    // sortHospitalsByLocation();
  }

  void sortHospitalsByLocation() {
    print(coOrdinates);
    coOrdinates[0].sort((a, b) => a[2].compareTo(b[2]));
    setState(() {});
    print(coOrdinates);
  }

  loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  pickImage() async {
    var image = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image!);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image!);
  }

  String buildResult(dynamic output) {
    switch (output['index']) {
      case 0:
        return "you might be infected with covid-19";

      case 1:
        return "you might have less chances of being infected with covid-19";

      case 2:
        return "Please select a valid chest x-ray image";

      default:
        return "No result fould for the given input data";
    }
  }

  bubbleSort(List array) {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j][2] > array[j + 1][2]) {
          // Swapping using temporary variable
          var temp = array[j];
          array[j] = array[j + 1];
          array[j + 1] = temp;
        }
      }
    }
    return (array);
  }

  Widget hospitalRecomendation() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.blueGrey[100], borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(
            "Hospital recomendation based on your current location",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: coOrdinates[0].length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 15),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            coOrdinates[0][index][0],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            "${calculateDistance(coOrdinates[0][index][1], LatLng(myPosition!.latitude, myPosition!.longitude)).toString()} KM",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dianose xray for covid"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40),
                Container(
                  color: Colors.yellow[500],
                  padding: EdgeInsets.all(10),
                  child: Text(
                      " * Note : The Tests done here are not accurate for medical use . Do not make decidions based on these prediction. *",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("COVID Prediction",
                    style: TextStyle(
                      color: Color(0xFFE99600),
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                    )),
                //  hospitalRecomendation(),
                SizedBox(height: 30),
                Center(
                    child: _loading
                        ? Container(
                            width: 200,
                            child: Column(
                              children: <Widget>[
                                // Image.network(
                                //   "",
                                //   cacheHeight: 200,
                                //   cacheWidth: 200,
                                // ),
                                SizedBox(height: 50),
                              ],
                            ))
                        : Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 250,
                                  child: Image.file(_image!),
                                ),
                                SizedBox(height: 20),
                                _output != null
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        child: Text(
                                          buildResult(_output![0]),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      )
                                    : Container(),
                                _output![0]['index'] == 0
                                    ? hospitalRecomendation()
                                    : SizedBox.shrink()
                              ],
                            ),
                          )),
                Container(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(top: 1.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text('  ',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF26C6DA),
                                )),
                            new Text(
                              '',
                              style: new TextStyle(
                                  fontSize: 35.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF26C6DA)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => pickImage(),
                          child: Container(
                              width: MediaQuery.of(context).size.width - 110,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 17,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text("Take a photo",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20))),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => pickGalleryImage(),
                          child: Container(
                              width: MediaQuery.of(context).size.width - 110,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 17,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text("Select from the storage",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20))),
                        ),
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}
