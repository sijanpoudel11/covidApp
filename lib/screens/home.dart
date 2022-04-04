import 'dart:convert';
import 'dart:math';

import 'package:covid_aware_app/data.dart';
import 'package:covid_aware_app/screens/countryScreen.dart';
import 'package:covid_aware_app/screens/faqScreen.dart';
import 'package:covid_aware_app/screens/mapScreen.dart';
import 'package:covid_aware_app/screens/xrayTestScreen.dart';
import 'package:covid_aware_app/widgets/MostAffectedCountries.dart';
import 'package:covid_aware_app/widgets/worldWidePanel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map? worldData;
  List? countryData;
  Position? myPosition;
  Map? myCountry;
  void launchUrl() async {
    const url = 'https://covid19responsefund.org/';
    // if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    );
    //  } else {
    //  throw 'Could not launch $url';
    // }
  }

  void fetchWorldData() async {
    var response =
        await http.get(Uri.parse('https://disease.sh/v3/covid-19/all'));
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  void fetchCountryData() async {
    var response =
        await http.get(Uri.parse('https://disease.sh/v3/covid-19/countries'));
    var tempdata = json.decode(response.body);
    print(tempdata.length);
    for (var i = 0; i < tempdata!.length - 1; i++) {
      for (var j = i; j < tempdata!.length; j++) {
        if (tempdata![j]['deaths'] > tempdata![i]['deaths']) {
          var temp = tempdata![j];
          tempdata![j] = tempdata![i];
          tempdata![i] = temp;
        }
      }
    }

    setState(() {
      countryData = tempdata;
    });
  }

  double degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  String calculateDistance(LatLng location1, LatLng location2) {
    var earthRadiusKm = 6371;
    var dLat = degreesToRadians(location2.latitude - location1.latitude);
    var dLong = degreesToRadians(location2.longitude - location1.longitude);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(location2.latitude)) *
            cos(degreesToRadians(location1.latitude)) *
            sin(dLong / 2) *
            sin(dLong / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = (earthRadiusKm * c).toStringAsFixed(2);

    print(d);
    return d;
  }

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

  void sortHospitalsByLocation() {
    print(coOrdinates);
    coOrdinates[0].sort((a, b) => a[2].compareTo(b[2]));
    setState(() {});
    print(coOrdinates);
  }

  bubbleSort(List array) {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (double.parse(array[j][2]) > double.parse(array[j + 1][2])) {
          // Swapping using temporary variable
          var temp = array[j];
          array[j] = array[j + 1];
          array[j + 1] = temp;
        }
      }
    }
    return (array);
  }

  List<List> coOrdinates = [
    [
      [
        "Bir hospital",
        LatLng(27.7048249, 85.3136514),
      ],
      [
        'Patan hospital',
        LatLng(27.6682930, 85.3204918),
      ],
      [
        'Medicity hospital',
        LatLng(27.6623027, 85.3030976),
      ],
      [
        'Sahid memorial hospital',
        LatLng(27.6945252, 85.2810589),
      ],
      [
        'Green city hospital',
        LatLng(27.7371433, 85.3229969),
      ],
      [
        'Star hospital',
        LatLng(27.6817829, 85.3029565),
      ],
      [
        'Teaching hospital',
        LatLng(27.7353254, 85.3310080),
      ],
      [
        'Sukraraj Tropical Hospital',
        LatLng(27.6955125, 85.3063156),
      ],
      [
        'Blue Cross Hospital',
        LatLng(27.6936824, 85.3151572),
      ],
      [
        "Norvic Int'l Hospital",
        LatLng(27.6898622, 85.3191818),
      ],
      [
        "Om Hospital & Research Center",
        LatLng(27.7213600, 85.3448321),
      ],
      [
        "Katmandu Valley Hospital",
        LatLng(27.6992826, 85.3106839),
      ]
    ]
  ];

  @override
  void initState() {
    fetchWorldData();
    fetchCountryData();
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    var response = await http
        .get(Uri.parse('https://disease.sh/v3/covid-19/countries/Nepal'));
    setState(() {
      myCountry = json.decode(response.body);
    });
    myPosition = await getPosition();
    print(coOrdinates);
    calculateAllDistance();
    bubbleSort(coOrdinates[0]);
    print(coOrdinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19 Prediction App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Worldwide',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: primaryBlack,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    COUNTRYSCREEN(countryData: countryData!)));
                      },
                      child: Text(
                        'Regional',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ))
                ],
              ),
            ),
            worldData == null
                ? Center(child: CircularProgressIndicator())
                : WorldWidePanel(
                    worldData: worldData!,
                  ),
            // my countris stats
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'My Country ',
                style: TextStyle(
                    fontSize: 22,
                    color: primaryBlack,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // addCountry(context),
            //  mapsSection(context),
            checkxray(context),
            myCountry == null
                ? Center(child: CircularProgressIndicator())
                : myCountryData(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Most Affected Countries',
                style: TextStyle(
                    fontSize: 22,
                    color: primaryBlack,
                    fontWeight: FontWeight.bold),
              ),
            ),
            countryData == null
                ? Center(child: CircularProgressIndicator())
                : MostAffectedCountries(counrtyList: countryData!),
            faq(context),
            donate()
          ],
        ),
      ),
    );
  }

  InkWell donate() {
    return InkWell(
      onTap: launchUrl,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 20, left: 5, right: 5, top: 5),
        decoration: BoxDecoration(color: primaryBlack),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DONATE',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  InkWell faq(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FAQSCREEN()));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10, left: 5, right: 5, top: 20),
        decoration: BoxDecoration(color: primaryBlack),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'FAQs',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  Container myCountryData() {
    return Container(
      color: Colors.grey[300],
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(20),
      //  height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                myCountry!['country'],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Image.network(
                myCountry!['countryInfo']['flag'],
                height: 30,
              )
            ],
          ),
          Expanded(
              child: Container(
            child: Column(
              //  crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CONFIRMED : ${myCountry!['cases']}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'ACTIVE : ${myCountry!['active']}',
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'RECOVERED : ${myCountry!['recovered']}',
                  style: TextStyle(color: Colors.green),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'DEATHS : ${myCountry!['deaths']}',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Padding addCountry(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: primaryBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add),
            Text(
              myCountry == null ? 'Add your country ' : ' Change your country',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Padding checkxray(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: primaryBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => XrayTestScreen()));
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined),
            Text(
              'Covid Test',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Padding mapsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: primaryBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MapScreen()));
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined),
            Text(
              ' Maps Section',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
