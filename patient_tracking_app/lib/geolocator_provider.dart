import "package:flutter/widgets.dart";
import "package:geolocator/geolocator.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import 'package:flutter/services.dart';

// Define the MethodChannel for permission handling
const MethodChannel platform = MethodChannel('location_permission');

// Define the EventChannel for receiving location updates
const EventChannel eventChannel = EventChannel('location_updates');

final geolocatorProvider = StreamProvider<Position>((ref) async* {
  debugPrint("Initializing GeoLocator");

  // Step 1: Check and request permission using Geolocator
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Location permissions are denied");
    }
  }

  // Step 2: Use the startLocationUpdates function to request location updates
  await startLocationUpdates();

  // Step 3: Listen for coordinates from the EventChannel
  yield* eventChannel.receiveBroadcastStream().map((event) {
    List<double> coords = parseCoordinates(event);
    // Create a Position object from the coordinates
    Position position = Position(
      longitude: coords[1], // Longitude
      latitude: coords[0], // Latitude
      timestamp: DateTime.now(), // Current timestamp
      accuracy: 0.0, // Accuracy can be set as needed
      altitude: 0.0, // Altitude can be set as needed
      speed: 0.0, // Speed can be set as needed
      heading: 0.0, // Heading can be set as needed
      speedAccuracy: 0.0, // Speed accuracy can be set as needed
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
    debugPrint("Yielding Position: $position");
    return position; // Yielding the Position object
  });
});

// Function to start location updates
Future<void> startLocationUpdates() async {
  try {
    // Request permission from the native platform
    await platform.invokeMethod('requestPermission');

    // Check if permission is granted
    final bool result = await platform.invokeMethod('checkPermission');

    if (result) {
      // Start listening to the EventChannel for location updates
      eventChannel.receiveBroadcastStream().listen((event) {
        List<double> coords = parseCoordinates(event);
        print("Coordinates: $coords");
      });
    }
  } on PlatformException catch (e) {
    print("Failed to start location updates: '${e.message}'");
  }
}

// Example function to parse coordinates from the event stream
List<double> parseCoordinates(dynamic event) {
  // Assuming the event is a string like "latitude longitude"
  List<String> parts = (event as String).split(' ');
  double latitude = double.parse(parts[0]);
  double longitude = double.parse(parts[1]);
  return [latitude, longitude];
}
