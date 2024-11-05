import 'dart:async';

import 'package:flutter/material.dart';

class NoPulseScreen extends StatefulWidget {
  const NoPulseScreen({super.key});

  @override
  _NoPulseScreenState createState() => _NoPulseScreenState();
}

class _NoPulseScreenState extends State<NoPulseScreen> {
  int countdown = 20;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (countdown > 1) {
        setState(() {
          countdown--;
        });
      } else {
        t.cancel();
        cancelCountdown();
        // Action when countdown reaches zero
        // For now, we'll just cancel the timer.
      }
    });
  }

  void cancelCountdown() {
    timer?.cancel();
    Navigator.pop(context); // Close the screen when cancel is pressed
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.redAccent,
                width: 4,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                'No pulse\ndetected',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Calling emergency services in ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: '$countdown',
                      style: TextStyle(
                        color: Colors.red[200],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: cancelCountdown,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ],
      ),
    );
  }
}
