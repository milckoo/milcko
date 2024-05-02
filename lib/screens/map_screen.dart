import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milcko/provider/auth_provider.dart';
import 'package:milcko/provider/location_provider.dart';
import 'package:milcko/screens/home_screen.dart';
import 'package:milcko/screens/registration_screen.dart';
import 'package:provider/provider.dart';

import 'getstarted_screen.dart';

class MapScreen extends StatefulWidget {
  static String id = 'map-screen';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with ChangeNotifier{
  late LatLng currentLocation;
  late GoogleMapController _mapController;
  late var locationData = Provider.of<LocationProvider>(context);
  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<LocationProvider>(context,listen: true);

    setState(() {
  currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
  if (locationData.selectedAddresses != null) {
    print(locationData.selectedAddresses!.street);
    print(locationData.selectedAddresses!.locality);
  } else {
    print('Selected address is null');
  }
  notifyListeners();
});

    void onCreated(GoogleMapController controller){
      setState(() {
      _mapController = controller;
      notifyListeners();
      });
    }
    return Scaffold(
      body: Stack(
        children: [
            GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 14.4746,
            ),
            zoomControlsEnabled: false,
            minMaxZoomPreference: const MinMaxZoomPreference(1.5, 20.8),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            mapToolbarEnabled: true,
            onCameraMove: (CameraPosition position){
              locationData.onCameraMove(position);
              //locationData.updateLocation(position.target);
            },
            onMapCreated: onCreated,
            onCameraIdle: (){
              locationData.getMoveCamera();
            },
          ),
          Center(
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 40),
              child: Image.asset('lib/images/pin.png')
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 6,),
                          Text(
                            locationData.selectedAddresses?.street ?? 'Loading...',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize:25),
                          ),
                          Text(
                            locationData.selectedAddresses?.locality ?? 'Loading...',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: (){
                          navigateToNextScreen();
                        }, 
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)), 
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: const Text('Confirm Location',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),)
                      ),
                    ),
                    SizedBox(height: 15,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void navigateToNextScreen() async {
    final isUserLoggedIn = await Provider.of<AuthProvider>(context, listen: false).checkLoggedIn();
    if (isUserLoggedIn) {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegistrationScreen()));
    }
  }
  // void confirmLocation(LatLng currentLocation){
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const RegistrationScreen()));
  // }
}