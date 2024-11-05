import 'package:flutter/material.dart';
import 'package:flutter_wearos_location/no_pulse_screen.dart';

class BloodPressureScreen extends StatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  State<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  String systolic = '--';
  String diastolic = '--';
  bool isLoading = false;

  // Simulated function to fetch blood pressure data
  Future<void> fetchBloodPressure() async {
    setState(() {
      isLoading = true; // Start loading
    });

    // Simulate a delay as if fetching from a sensor
    await Future.delayed(const Duration(seconds: 2));

    // Fake data for blood pressure (systolic / diastolic)
    int fetchedSystolic = 120; // Example systolic value
    int fetchedDiastolic = 80; // Example diastolic value

    setState(() {
      systolic = fetchedSystolic.toString();
      diastolic = fetchedDiastolic.toString();
      isLoading = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate to NoPulseScreen when tapped
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NoPulseScreen()));
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SYS and DIA labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'SYS',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'DIA',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              // Blood pressure readings (e.g., 133/88)
              Text(
                '133 / 88',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
              // Unit label (mmHg)
              Text(
                'mmHg',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              // Heart rate (e.g., 101 bpm)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '101 bpm',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
