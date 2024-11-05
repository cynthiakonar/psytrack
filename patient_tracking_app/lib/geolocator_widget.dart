// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_wearos_location/geolocator_provider.dart'; // Import the Geolocator provider

class GeolocatorWidget extends HookConsumerWidget {
  const GeolocatorWidget({super.key});

  // Define restricted location
  final LatLng restrictedLocation = const LatLng(12.843026, 80.156539);
  final double restrictedRadius = 20.0; // 20 meters radius

  static List<UserModel> sampleUsers = [
    UserModel(
      userType: 'patient',
      name: 'John Doe',
      age: 17,
      wardNumber: 103,
      disorder: 'Anxiety',
      nurse: 'Nurse Alice',
      latitude: 12.842758,
      longitude: 80.157516,
      alertMessage: 'Doctor appointment at 3pm',
    ),
    UserModel(
      userType: 'patient',
      name: 'Jane Smith',
      age: 18,
      wardNumber: 104,
      disorder: 'Depression',
      nurse: 'Nurse Bob',
      latitude: 12.841777,
      longitude: 80.157378,
    ),
    UserModel(
      userType: 'patient',
      name: 'Tom White',
      age: 19,
      wardNumber: 105,
      disorder: 'PTSD',
      nurse: 'Nurse Clara',
      latitude: 12.842110,
      longitude: 80.155785,
      alertMessage: 'Medication checkup at 4pm',
    ),
    UserModel(
      userType: 'patient',
      name: 'Emily Clark',
      age: 20,
      wardNumber: 106,
      disorder: 'Bipolar Disorder',
      nurse: 'Nurse David',
      latitude: 12.843026,
      longitude: 80.156539,
      alertMessage: 'Inside Restricted Area',
    ),
    UserModel(
      userType: 'doctor',
      name: 'Dr. Martin',
      age: 45,
      latitude: 12.841427,
      longitude: 80.156682,
      alertMessage: 'On call for emergencies',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(geolocatorProvider);

    return Scaffold(
      body: position.when(
        data: (position) {
          return FutureBuilder<Map<String, BitmapDescriptor>>(
            future:
                _getCustomIcons(), // Load both icons for doctors and patients
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final icons = snapshot.data!;
              final currentPosition =
                  LatLng(position.latitude, position.longitude);

              // Check if the current position is within the restricted area
              _checkForRestrictedArea(context, currentPosition);

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(12.842293, 80.157097),
                  // position.latitude,
                  //   position.longitude), // Set to the current user's position
                  zoom: 17,
                ),
                markers: _createMarkers(position,
                    icons), // Pass the custom icons for doctors and patients
                circles:
                    _createRestrictedAreaCircle(), // Add restricted area circle
              );
            },
          );
        },
        error: (error, stackTrace) {
          debugPrint("The following error occurred: ${error.toString()}");
          debugPrintStack(stackTrace: stackTrace);
          return Center(child: Text("Error: ${error.toString()}"));
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // Add red glowing circle for restricted area
  Set<Circle> _createRestrictedAreaCircle() {
    return {
      Circle(
        circleId: const CircleId('restricted_area'),
        center: restrictedLocation,
        radius: restrictedRadius,
        strokeColor: Colors.red.withOpacity(0.2),
        fillColor: Colors.red.withOpacity(0.4), // Base opacity
        strokeWidth: 4,
      ),
    };
  }

  // Function to generate map markers from the user list
  Set<Marker> _createMarkers(
      Position currentUserPosition, Map<String, BitmapDescriptor> icons) {
    final userMarkers = sampleUsers.map((user) {
      // Select the appropriate icon based on the user type
      final icon =
          user.userType == 'doctor' ? icons['doctor']! : icons['patient']!;

      return Marker(
        markerId: MarkerId(user.name),
        position: LatLng(
            user.latitude, user.longitude), // Marker position from sample data
        icon: icon, // Use the appropriate icon
        infoWindow: InfoWindow(
          title: user.userType == 'doctor'
              ? "${user.name} (Doctor)"
              : "${user.name} (${user.wardNumber})",
          snippet: _getMarkerDescription(user),
        ),
      );
    }).toSet();

    // Add current user marker with a custom rounded icon (could be different from doctor/patient)
    userMarkers.add(
      Marker(
        markerId: const MarkerId('current_user'),
        position: LatLng(12.842293, 80.157097),
        // currentUserPosition.latitude, currentUserPosition.longitude),
        icon: icons[
            'current_user']!, // Use a custom location icon for current user
        infoWindow: const InfoWindow(
          title: 'You are here',
        ),
      ),
    );

    return userMarkers;
  }

  // Function to get the marker description based on the user type
  String _getMarkerDescription(UserModel user) {
    if (user.userType == 'doctor') {
      return user.alertMessage ?? "";
    } else {
      return user.alertMessage ?? 'Disorder: ${user.disorder}';
    }
  }

  // Function to load custom icons for doctor, patient, and current user
  Future<Map<String, BitmapDescriptor>> _getCustomIcons() async {
    final doctorIcon = await _resizeImage('assets/location_blue.png', 48);
    final patientIcon = await _resizeImage('assets/location_red.png', 48);
    final currentUserIcon = await _resizeImage('assets/location_green.png', 48);

    return {
      'doctor': doctorIcon,
      'patient': patientIcon,
      'current_user': currentUserIcon,
    };
  }

  // Helper function to resize and return a BitmapDescriptor
  Future<BitmapDescriptor> _resizeImage(String imagePath, int size) async {
    final ByteData imageData = await rootBundle.load(imagePath);
    final codec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: size,
      targetHeight: size,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImage = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedImage);
  }

  // Function to check if the user enters a restricted area
  void _checkForRestrictedArea(BuildContext context, LatLng currentPosition) {
    final distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      restrictedLocation.latitude,
      restrictedLocation.longitude,
    );

    if (distance <= restrictedRadius) {
      _showRestrictedAreaAlert(context);
    }
  }

  // Function to show alert if user enters restricted area
  void _showRestrictedAreaAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restricted Area'),
          content: const Text('You have entered a restricted area!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
