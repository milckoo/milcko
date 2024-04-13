import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milcko/provider/auth_provider.dart';
import 'package:milcko/screens/home_screen.dart';
import 'package:milcko/screens/registration_screen.dart';
import 'package:provider/provider.dart';

class GetStartedScreen extends StatefulWidget {
  static const String id = 'getstarted-screen';
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context,listen: false);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/images/deliveryboy.png'),
          const SizedBox(
            height: 70,
          ),
          const Text("Let's get started",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          const SizedBox(
            height: 10,
          ),
          const Text('Never a better time than now to Start',style: TextStyle(color: Colors.grey),),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                        onPressed: (){
                          print('Navigated from GetStarted screen');
                          ap.isSignedIn == true? // when true, fetch shared preference data
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context)=> HomeScreen(currentLocation: LatLng(0.0, 0.0),))):

                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context)=> const RegistrationScreen()));
                        }, 
                        style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          ),),
                        ),
                        child: const Text('Get Started', style: TextStyle(fontSize: 16)),),
                            ),
          )
        ],),
    );
  }
}