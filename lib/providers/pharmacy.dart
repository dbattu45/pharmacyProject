import 'package:flutter/foundation.dart';
import 'package:pharmacies2/providers/medication.dart';

// pharmacy model
class Pharmacy with ChangeNotifier {
  final String id;
  final String name;
  final String address;
  final dynamic phoneNo;
  final dynamic hours;
  bool isOrderedFrom;
  List<Medication> medications;
  double latitude;
  double longitude;

  Pharmacy(
    {required this.id,
      required this.name,
      required this.address,
      required this.phoneNo,
      required this.hours,
      this.isOrderedFrom = false,
      required this.medications,
      required this.latitude,
      required this.longitude});

  void setPharmacyHasBeenOrderedFrom() {
    isOrderedFrom = true;
    notifyListeners();
  }
}
