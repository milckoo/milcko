import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milcko/widgets/constants.dart';
import 'package:milcko/widgets/image_slider.dart';
import 'package:milcko/widgets/promo_cards.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  static String id = 'home-screen';
  
  late LatLng currentLocation;
  //final LatLng confirmedLocation = this.currentLocation;
  //HomeScreen({super.key,required currentLocation});
  // ignore: use_super_parameters
  HomeScreen({Key? key, required this.currentLocation}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    const PageContent(
      imageAsset: 'lib/images/enteraddress.png',
      text: 'Set Your Delivery Location',
    ),
    const PageContent(
      imageAsset: 'lib/images/ordermilk.png',
      text: 'Order Fresh Farm Milk From Milcko',
    ),
    const PageContent(
      imageAsset: 'lib/images/deliveryboy.png',
      text: 'Eco Friendly Delivery at your DoorStep',
    ),
  ];

class _HomeScreenState extends State<HomeScreen> {

  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    const PageContent(
      imageAsset: 'lib/images/enteraddress.png',
      text: 'Set Your Delivery Location',
    ),
    const PageContent(
      imageAsset: 'lib/images/ordermilk.png',
      text: 'Order Fresh Farm Milk From Milcko',
    ),
    const PageContent(
      imageAsset: 'lib/images/deliveryboy.png',
      text: 'Eco Friendly Delivery at your DoorStep',
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(Duration(seconds: 3), () {
      if (_currentPage == _pages.length - 1) {
        _controller.jumpToPage(0);
      } else {
        _controller.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      _startAutoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {

    final LatLng currentLocation = widget.currentLocation;
    return Scaffold(
      body: ListView(
        children: [
          Row(
            children: [
              const SizedBox(width: 10,),
              // Hello Humans Greetings
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Hello Humans!',
                  style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500,),),
                  ShaderMask(shaderCallback: (bounds) => 
                  LinearGradient(
                    colors: [
                    Color(0xFFFFA400),
                    Colors.black.withOpacity(0.7),
                  ]).createShader(
                    bounds,
                  ),
                  child: const Text('Get The Right One For The',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
                  ),
                  ShaderMask(shaderCallback: (bounds) => 
                  LinearGradient(colors: [
                    Color(0xFFFFBF4D),
                    Colors.black.withOpacity(0.4),
                  ]).createShader(
                    bounds,
                  ),
                  child: const Text('Better Health',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
                  ),
                  
                ],
              ),
              // SizedBox(width: 40,),
              // location Icon Clickable
              Image.asset('lib/images/pin.png',height: 20,width: 20,),
              Text('${currentLocation.latitude}\n${currentLocation.longitude}'),
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
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     Container(
              //       height: 60,width: 60,
              //       decoration: BoxDecoration(color: Color.fromARGB(255, 175, 223, 246),borderRadius: BorderRadius.circular(20)),),
              //     Image.asset('lib/images/first_category.png',width: 50,height: 50,),
              //   ],
              // ),
              PromoCard(),
              SizedBox(width: 15,),
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     Container(
              //       height: 60,width: 60,
              //       decoration: BoxDecoration(color: Color.fromARGB(255, 198, 229, 244),borderRadius: BorderRadius.circular(20)),),
              //     Image.asset('lib/images/second_category.png',width: 50,height: 50,),
              //   ],
              // ),
              PromoCard(),
              SizedBox(width: 15,),
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     Container(
              //       height: 60,width: 60,
              //       decoration: BoxDecoration(color: Color.fromARGB(255, 249, 193, 211),borderRadius: BorderRadius.circular(20)),),
              //     Image.asset('lib/images/third_category.png',width: 50,height: 50,),
              //   ],
              // ),
              PromoCard(),
              SizedBox(width: 15,),
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     Container(
              //       height: 60,width: 60,
              //       decoration: BoxDecoration(color: Color.fromARGB(255, 158, 188, 202),borderRadius: BorderRadius.circular(20)),),
              //     Image.asset('lib/images/fourth_category.png',width: 50,height: 50,),
              //   ],
              // ),
              PromoCard(),
              SizedBox(width: 15,),
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     Container(
              //       height: 60,width: 60,
              //       decoration: BoxDecoration(color: const Color.fromARGB(255, 215, 154, 174),borderRadius: BorderRadius.circular(20)),),
              //     Image.asset('lib/images/fifth_category.png',width: 50,height: 50,),
              //   ],
              // ),
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
                  //Image.asset('lib/images/first_category.png',alignment: Alignment.center,),
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
                              TextSpan(text: '55 Rs.\n',style: TextStyle(color: Colors.black)),
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
                  //Image.asset('lib/images/first_category.png',alignment: Alignment.center,),
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
class PageContent extends StatelessWidget {
  final String imageAsset;
  final String text;

  const PageContent({
    required this.imageAsset,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.asset(imageAsset),
          ),
        Text(
          text,
          style: kPageViewTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
