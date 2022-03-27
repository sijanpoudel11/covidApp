import 'package:covid_aware_app/data.dart';
import 'package:flutter/material.dart';

class COUNTRYSCREEN extends StatefulWidget {
  const COUNTRYSCREEN({Key? key, required this.countryData}) : super(key: key);
  final List countryData;

  @override
  _COUNTRYSCREENState createState() => _COUNTRYSCREENState();
}

class _COUNTRYSCREENState extends State<COUNTRYSCREEN> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Regional Data',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: primaryBlack,
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: widget.countryData.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.grey[200],
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
                        widget.countryData[index]['country'],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image.network(
                        widget.countryData[index]['countryInfo']['flag'],
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
                          'CONFIRMED : ${widget.countryData[index]['cases']}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'ACTIVE : ${widget.countryData[index]['active']}',
                          style: TextStyle(color: Colors.blue),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'RECOVERED : ${widget.countryData[index]['recovered']}',
                          style: TextStyle(color: Colors.green),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'DEATHS : ${widget.countryData[index]['deaths']}',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            );
          }),
    );
  }
}
