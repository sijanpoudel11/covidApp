import 'package:covid_aware_app/data.dart';
import 'package:flutter/material.dart';

class MostAffectedCountries extends StatelessWidget {
  const MostAffectedCountries({Key? key, required this.counrtyList})
      : super(key: key);
  final List counrtyList;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      counrtyList[index]['countryInfo']['flag'],
                      height: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      counrtyList[index]['country'],
                      style: TextStyle(color: primaryBlack, fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Cases : ${counrtyList[index]['cases']}',
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        ),
                        Text(
                          'Deaths : ${counrtyList[index]['deaths']}',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
