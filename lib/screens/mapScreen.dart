import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(45.5180008, 9.2125),
    zoom: 17,
  );
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  List<List> coOrdinates = [];

  List<Marker> allMarkers = [];
  Position? myPosition;
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

  void calculateDistance(LatLng location1, LatLng location2) {
    var earthRadiusKm = 6371;
    var dLat = degreesToRadians(location2.latitude - location1.latitude);
    var dLong = degreesToRadians(location2.longitude - location1.longitude);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(location2.latitude)) *
            cos(degreesToRadians(location1.latitude)) *
            sin(dLong / 2) *
            sin(dLong / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = earthRadiusKm * c;
    print(d);
  }

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    makeMarker();
    myPosition = await getPosition();
  }

  void makeMarker() {
    coOrdinates = [
      [
        'U2 Universita Milano Bicocca',
        LatLng(45.513218227614125, 9.21072419732809),
        'U2 University of Milan Bicocca',
      ],
      [
        'U3 Universita Milano Bicocca',
        LatLng(45.51374449740213, 9.212186001241207),
        'U3 University of Milan Bicocca',
      ],
      [
        'U4 Universita Milano Bicocca',
        LatLng(45.514229882942075, 9.2116804048419),
        'U4 University of Milan Bicocca',
      ],
      [
        'U5 Universita Milano Bicocca',
        LatLng(45.51222511492551, 9.21246662735939),
        'U5 University of Milan Bicocca',
      ],
      [
        'U7 Universita Milano Bicocca',
        LatLng(45.5170514265314, 9.213347397744656),
        'U7 University of Milan Bicocca',
      ],
      [
        "MODELLI DELLA CONCORRENZA",
        LatLng(45.513183338195134, 9.20980155645155),
        "MODELLI DELLA CONCORRENZA",
      ],
    ];
    for (int i = 0; i < coOrdinates.length; i++) {
      allMarkers.add(
        Marker(
          markerId: MarkerId(coOrdinates[i][0]),
          position: coOrdinates[i][1],
          onTap: () {
            print("clicked on ${coOrdinates[i][1]}");
            calculateDistance(coOrdinates[i][1],
                LatLng(myPosition!.latitude, myPosition!.longitude));
          },
        ),
      );
    }
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyAJMkB_0FXJzHNy6XOhMqLtdbWLTnWJR04",
        PointLatLng(myPosition!.latitude, myPosition!.longitude),
        PointLatLng(27.7273554, 85.2540521));

    if (result.status == "OK") {
      result.points.forEach((point) {
        polylineCordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            polylineId: PolylineId('id 1'),
            color: Colors.red,
            width: 10,
            points: polylineCordinates));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'maps',
          style: TextStyle(fontSize: width * 5),
        ),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        initialCameraPosition: _initialCameraPosition,
        polylines: _polylines,
        markers: Set<Marker>.of(allMarkers),
        onMapCreated: (controller) {
          setPolylines();
        },
      ),
    );
  }
}
