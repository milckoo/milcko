// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class PromoCard extends StatefulWidget {
//   const PromoCard({super.key});

//   @override
//   State<PromoCard> createState() => _PromoCardState();
// }

// class _PromoCardState extends State<PromoCard> {
//   late Future<List<DocumentSnapshot>> _sliderImagesFuture = getPromoCardImagesFromDb();


//   void initState() {
//     _sliderImagesFuture = getPromoCardImagesFromDb();
//     super.initState();
//   }
//   Future<List<DocumentSnapshot>> getPromoCardImagesFromDb() async {
//     var _firestore = FirebaseFirestore.instance;
//     QuerySnapshot snapShot = await _firestore.collection('promocard').get();

//     return snapShot.docs;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     height: 60,width: 60,
//                     decoration: BoxDecoration(color: const Color.fromARGB(255, 215, 154, 174),borderRadius: BorderRadius.circular(20)),),
//                     // Image.asset('lib/images/fifth_category.png',width: 50,height: 50,),
//                     DocumentSnapshot promoCardImage = snapshot.data![index];
//               Map<String, dynamic> getImage = sliderImage.data() as Map<String, dynamic>;
//                     Image.network(getImage['image'])
//                 ],
//               );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: getPromoCardImagesFromDb(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Text('No promo card images found');
        } else {
          DocumentSnapshot promoCardImage = snapshot.data![0]; // Assuming you want to display the first image
          Map<String, dynamic> getImage = promoCardImage.data() as Map<String, dynamic>;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 215, 154, 174),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Image.network(getImage['image'],height: 50,width: 50,),
            ],
          );
        }
      },
    );
  }

  Future<List<DocumentSnapshot>> getPromoCardImagesFromDb() async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapShot = await _firestore.collection('promocard').get();

    return snapShot.docs;
  }
}
