import "package:flutter/material.dart";
import "package:flutter_wearos_location/alert_screen.dart";
import "package:flutter_wearos_location/bp_screen.dart";
import "package:flutter_wearos_location/geolocator_widget.dart";
import "package:flutter_wearos_location/schedule_screen.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

enum Route {
  mainMenu,
  bloodPressure,
  geoLocator,
  schedule,
  alert;

  String get route => "/$this";
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: "Smart Tracking Watch",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
        ),
        initialRoute: Route.mainMenu.route,
        routes: {
          Route.mainMenu.route: (BuildContext context) => const MainMenu(),
          Route.bloodPressure.route: (BuildContext context) =>
              const BloodPressureScreen(),
          Route.geoLocator.route: (BuildContext context) =>
              const GeolocatorWidget(),
          Route.schedule.route: (BuildContext context) =>
              const ScheduleListView(),
          Route.alert.route: (BuildContext context) => const AlertListScreen(),
        },
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.amber,
                      padding: EdgeInsets.only(top: 30, left: 10),
                      child: PackageButton(
                        text: "Blood Pressure", //"Patients" list screen button
                        route: Route.bloodPressure,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 30, right: 10),
                      color: Colors.cyan,
                      child: PackageButton(
                        text: "Location",
                        route: Route.geoLocator,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.lightGreen,
                      padding: EdgeInsets.only(bottom: 30, left: 10),
                      child: PackageButton(
                        text: "Schedule",
                        route: Route.schedule,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.pinkAccent,
                      padding: EdgeInsets.only(bottom: 30, right: 10),
                      child: PackageButton(
                        text: "Alerts",
                        route: Route.alert,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageButton extends StatelessWidget {
  final String text;
  final Route route;

  const PackageButton({super.key, required this.text, required this.route});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(route.route);
      },
      child: Text(text),
    );
  }
}

class FlutterWearOSLocation extends StatelessWidget {
  const FlutterWearOSLocation({super.key}) : super();

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Colors.white,
      child: Center(
        child: Card(
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: GeolocatorWidget(),
          ),
        ),
      ),
    );
  }
}
