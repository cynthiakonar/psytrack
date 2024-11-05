class UserModel {
  final String userType; // "patient" or "doctor"
  final String name;
  final int age;
  final int? wardNumber; // Null for doctors
  final String? disorder; // Null for doctors
  final String? nurse; // Null for doctors
  final double latitude;
  final double longitude;
  final String? alertMessage; // Null if no alert message

  UserModel({
    required this.userType,
    required this.name,
    required this.age,
    this.wardNumber,
    this.disorder,
    this.nurse,
    required this.latitude,
    required this.longitude,
    this.alertMessage,
  });
}
