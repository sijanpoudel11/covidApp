import 'package:covid_aware_app/data.dart';
import 'package:flutter/material.dart';

class FAQSCREEN extends StatelessWidget {
  const FAQSCREEN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlack,
        title: Text('FAQs'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: DataSource.questionAnswers.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(DataSource.questionAnswers[index]['question']),
              children: [
                Column(
                  children: [Text(DataSource.questionAnswers[index]['answer'])],
                )
              ],
            );
          }),
    );
  }
}
