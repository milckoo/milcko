import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milcko/provider/location_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static String id = 'map-screen';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late LatLng currentLocation;
  late GoogleMapController _mapController;
  late final locationData = Provider.of<LocationProvider>(context);
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });
    void onCreated(GoogleMapController controller){
      setState(() {
      _mapController = controller;
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
            },
            onMapCreated: onCreated,
            onCameraIdle: (){
              //locationData.getMoveCamera();
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
              child: Column(
                children: [
                  Text(locationData.selectedAddresses?.featureName ?? '',style:const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  Text(locationData.selectedAddresses?.addressLine ?? '',style:const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}