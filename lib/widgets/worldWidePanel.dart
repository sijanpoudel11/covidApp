import 'package:flutter/material.dart';

class WorldWidePanel extends StatelessWidget {
  const WorldWidePanel({Key? key, required this.worldData}) : super(key: key);
  final Map worldData;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2),
        children: [
          GridPanel(
            title: 'CONFIRMED',
            count: worldData['cases'].toString(),
            panelColor: Colors.grey[200],
            textColor: Colors.grey[600],
          ),
          GridPanel(
            title: 'ACTIVE',
            count: worldData['active'].toString(),
            panelColor: Colors.blue[200],
            textColor: Colors.blue[600],
          ),
          GridPanel(
            title: 'RECOVERED',
            count: worldData['recovered'].toString(),
            panelColor: Colors.green[200],
            textColor: Colors.green[600],
          ),
          GridPanel(
            title: 'DEATHS',
            count: worldData['deaths'].toString(),
            panelColor: Colors.red[200],
            textColor: Colors.red[600],
          )
        ],
      ),
    );
  }
}

class GridPanel extends StatelessWidget {
  final Color? panelColor;
  final Color? textColor;
  final String title;
  final String count;

  const GridPanel(
      {Key? key,
      required this.panelColor,
      required this.textColor,
      required this.title,
      required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: panelColor,
      ),
      alignment: Alignment.center,
      margin: EdgeInsets.all(5),
      height: 80,
      width: width / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            count,
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
