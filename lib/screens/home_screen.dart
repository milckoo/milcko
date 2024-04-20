import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milcko/widgets/image_slider.dart';
import 'package:milcko/widgets/promo_cards.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home-screen';

  final LatLng currentLocation;

  HomeScreen({Key? key, required this.currentLocation}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String address = '';

  @override
  void initState() {
    super.initState();
    getAddressFromCoordinates(widget.currentLocation);
  }

  Future<void> getAddressFromCoordinates(LatLng coordinates) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          address =
          "${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}";
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng currentLocation = widget.currentLocation;

    return Scaffold(
      body: ListView(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Hello Humans!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Color(0xFFFFA400),
                        Colors.black.withOpacity(0.7),
                      ],
                    ).createShader(
                      bounds,
                    ),
                    child: const Text(
                      'Get The Right One For The',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Color(0xFFFFBF4D),
                        Colors.black.withOpacity(0.4),
                      ],
                    ).createShader(
                      bounds,
                    ),
                    child: const Text(
                      'Better Health',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Image.asset(
                'lib/images/pin.png',
                height: 20,
                width: 20,
              ),
              Text('${address ?? 'Loading...'}'),
            ],
          ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
    children: [
    Expanded(
    child: TextField(
    decoration: InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 15),
    hintText: 'Search for better Health',
    prefixIcon: const Icon(Icons.search,color: Colors.yellow,),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(),
    )
    ),
    ),
    ),
    const SizedBox(width: 5,),
    const Icon(Icons.shopping_bag_outlined,color: Colors.yellow,),
    ],
    ),
    ),
    const Padding(
    padding: EdgeInsets.all(10.0),
    child: Text('Category',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
    ),
    const SizedBox(height: 10,),
    Row(
    children: [
    SizedBox(width: 15,),
    PromoCard(),
    SizedBox(width: 15,),
    PromoCard(),
    SizedBox(width: 15,),
    PromoCard(),
    SizedBox(width: 15,),
    PromoCard(),
    SizedBox(width: 15,),
    PromoCard(),
    ]
    ),
    const SizedBox(height: 30,),
    ImageSlider(),
    const SizedBox(height: 30,),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Stack(
    alignment: Alignment.bottomCenter,
    children: [
    Container(
    height: 250,
    width: 170,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
    Color.fromARGB(255, 229, 134, 166),
    Color.fromARGB(255, 184, 17, 73),
    ],
    stops: [0.0,0.8]
    ),
    ),
    ),
    Container(
    height: 240,
    width: 160,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
    ),
    Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Image.asset('lib/images/first_category.png'),
    const SizedBox(height: 10,),
    const Text('Cow Milk'),
    const SizedBox(height: 10,),
    const Text('1000gm/1 litre'),
    Row(
    children: [
    RichText(text: const TextSpan(
    children: [
    TextSpan(text: '55 Rs.\n',style: TextStyle
      (color: Colors.black)),
      TextSpan(text: '60 Rs. ',style: TextStyle(color: Colors.black,decoration: TextDecoration.lineThrough))
    ]
    )),
      ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 159, 229, 161),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Text('Grab It',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),)
    ],
    )
    ],
    )
    ],
    ),
      const SizedBox(width: 20,),
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 250,
            width: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 229, 134, 166),
                    Color.fromARGB(255, 184, 17, 73),
                  ],
                  stops: [0.0,0.8]
              ),
            ),
          ),
          Container(
            height: 240,
            width: 160,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('lib/images/second_category.png'),
              const SizedBox(height: 10,),
              const Text('Cow Milk'),
              const SizedBox(height: 10,),
              const Text('1000gm/1 litre'),
              Row(
                children: [
                  RichText(text: const TextSpan(
                      children: [
                        TextSpan(text: '55 Rs.\n',style: TextStyle(color: Colors.black)),
                        TextSpan(text: '60 Rs. ',style: TextStyle(color: Colors.black,decoration: TextDecoration.lineThrough))
                      ]
                  )),
                  ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 150, 235, 153)),child: Text('Grab It'),)
                ],
              )
            ],
          )
        ],
      ),
    ],
    ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: const Color.fromARGB(255, 248, 239, 157)),
              child: Center(child: const Text('One More Image\n Subscription Plan',style: TextStyle(fontWeight: FontWeight.bold),)),
            ),
          )
        ],
      ),
    );
  }
}
