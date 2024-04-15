// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ImageSlider extends StatefulWidget {
//   const ImageSlider({super.key});

//   @override
//   State<ImageSlider> createState() => _ImageSliderState();
// }

// class _ImageSliderState extends State<ImageSlider> {

//   @override
//   void initState() {
//     getSliderImagesFromDb();
//     super.initState();
//   }

//   Future <List<DocumentSnapshot>> getSliderImagesFromDb() async {
//     var _firestore = FirebaseFirestore.instance;
//     QuerySnapshot snapShot = await _firestore.collection('slider').get();

//     return snapShot.docs;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           FutureBuilder(
//             future: getSliderImagesFromDb(), 
//             builder: (_,snapShot){
//               return snapShot.data == null ?
//               Container(
//                 child: const Center(child: Text('Images Not Found',style: TextStyle(color: Colors.black),)),
//               ): 
//               CarouselSlider.builder(
//                 itemCount: snapShot.data?.length, 
//                 itemBuilder: (context,int index, _) {
//                   DocumentSnapshot sliderImage = snapShot.data![index];
//                   Map getImage = sliderImage.data() as Map<String,dynamic> ;
//                   return Image.network(getImage['image']);
//                 }, 
//                 options: CarouselOptions(
//                   initialPage: 0,
//                   autoPlay: true,

//                 ));
//             },
//             )
//         ],
//       ),
//     );
//   }
// }
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late Future<List<DocumentSnapshot>> _sliderImagesFuture = getSliderImagesFromDb();

  @override
  void initState() {
    _sliderImagesFuture = getSliderImagesFromDb();
    super.initState();
  }

  Future<List<DocumentSnapshot>> getSliderImagesFromDb() async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapShot = await _firestore.collection('slider').get();

    return snapShot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _sliderImagesFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text('Images Not Found', style: TextStyle(color: Colors.black)));
        } else {
          return CarouselSlider.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index, _) {
              DocumentSnapshot sliderImage = snapshot.data![index];
              Map<String, dynamic> getImage = sliderImage.data() as Map<String, dynamic>;
              return Image.network(getImage['image']);
            },
            options: CarouselOptions(
              initialPage: 0,
              autoPlay: true,
            ),
          );
        }
      },
    );
  }
}
