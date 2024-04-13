import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milcko/provider/location_provider.dart';
import 'package:milcko/screens/home_screen.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static String id = 'map-screen';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with ChangeNotifier{
  late LatLng currentLocation;
  late GoogleMapController _mapController;
  //late final locationData = Provider.of<LocationProvider>(context);
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context,listen: true);

    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      print(locationData.selectedAddresses?.street);
      print(locationData.selectedAddresses?.locality);
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
              locationData.updateLocation(position.target);
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
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Center(
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 6,),
                          Text(
                            '${locationData.selectedAddresses?.street}', 
                            style:const TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 10),),
                          Text(
                            '${locationData.selectedAddresses?.locality}', 
                            style:const TextStyle(color: Colors.black, fontWeight: FontWeight.w400,fontSize: 10)),
                        ],
                      ),
                    ),
                
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pushReplacement(
                            context, MaterialPageRoute(
                              builder: (context)=> const HomeScreen()
                            )
                          );
                        }, 
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: const Text('Confirm Location',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}