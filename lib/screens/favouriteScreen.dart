// import 'package:covid_aware_app/data.dart';
// import 'package:flutter/material.dart';

// class FavouriteScreen extends StatelessWidget {
//   const FavouriteScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(' YourFavourites'),
//         centerTitle: true,
//         backgroundColor: primaryBlack,
//       ),
//       body: Column(
//         children: [
//           TextButton(
//             onPressed: () {},
//             child: Row(
//               children: [
//                 Icon(Icons.add,color: Colors.white,),
//                 Text('Add Your Favourites',style: TextStyle(color: Colors.white),),
//               ],
//             ),
//             style: TextButton.styleFrom(backgroundColor: primaryBlack),
//           ),
//           ListView.builder(itemCount: ,itemBuilder: (context,index){
//             return Container(  color: Colors.grey[200],
//               margin: EdgeInsets.only(bottom: 10),
//               padding: EdgeInsets.all(20),
//               //  height: 120,
//               child: Row(children: [Container(child: Column(children: [Text(''),Image.asset('',height: 30,),],),),
//               Expanded(child: Column(children: [Text(
//                           'CONFIRMED : ${widget.countryData[index]['cases']}',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           'ACTIVE : ${widget.countryData[index]['active']}',
//                           style: TextStyle(color: Colors.blue),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           'RECOVERED : ${widget.countryData[index]['recovered']}',
//                           style: TextStyle(color: Colors.green),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           'DEATHS : ${widget.countryData[index]['deaths']}',
//                           style: TextStyle(color: Colors.red),
//                         )],),),],),);
//           },)
//         ],
//       ),
//     );
//   }
// }
