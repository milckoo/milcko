import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider with ChangeNotifier{
  double? latitude;
  double? longitude;
  bool premissionAllowed = false;
  bool loading = false;
  var selectedAddresses;

  // ignore: non_constant_identifier_names
  Future<void> getCurrentPosition() async {
    // Check if location permission is granted
    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isGranted) {
      try {
        // Get current position if permission is granted
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (position != null) {
          // Update latitude and longitude
          latitude = position.latitude;
          longitude = position.longitude;
          premissionAllowed = true;
          notifyListeners();
        } else {
          // Handle case when position is null
          print('Failed to get current position');
        }
      } catch (e) {
        // Handle errors while getting current position
        print('Error getting current position: $e');
      }
    } else {
      // Handle case when location permission is not granted
      print('Location permission not granted');
    }
  }
  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }
}