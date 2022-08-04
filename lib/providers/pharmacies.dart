import 'package:flutter/material.dart';
import 'package:pharmacies2/providers/medication.dart';
import 'package:pharmacies2/providers/pharmacy.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class Pharmacies with ChangeNotifier {
  final List<Pharmacy> _allPharmacies = <Pharmacy>[];

// returns a list of all the pharmacies
  Future<List<Pharmacy>> get allPharmacies async {
    if (_allPharmacies.isEmpty) {
      final String response =
          await rootBundle.loadString('assets/pharmacies.json');
      final data = await json.decode(response);
      List<dynamic> pharmacyItems = data["pharmacies"];

      for (var pharmacyItem in pharmacyItems) {
        Pharmacy pharm = await fetchPharmacyDetails(pharmacyItem["pharmacyId"]);
        _allPharmacies.add(pharm);
      }
    }
    return _allPharmacies;
  }

// returns pharmacy model with all the details
  Future<Pharmacy> fetchPharmacyDetails(String pharmacyId) async {
    final response = await http.get(Uri.parse(
        'https://api-qa-demo.nimbleandsimple.com/pharmacies/info/$pharmacyId'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final body = await json.decode(response.body);
      dynamic details = body["value"];
      dynamic address = details["address"];

      return Pharmacy(
          name: details["name"],
          id: details["id"],
          address:
              '${address["streetAddress1"]}, ${address["city"]}, ${address["usTerritory"]}, ${address["postalCode"]}',
          phoneNo: details["primaryPhoneNumber"],
          hours: details["pharmacyHours"],
          latitude: address["latitude"],
          longitude: address["longitude"],
          medications: <Medication>[]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load pharmacy Details');
    }
  }

// returns a list of all the pharmacies that we didn't order from
  List<Pharmacy> get pharmaciesNotOrderedFrom {
    return _allPharmacies
        .where((pharmItem) => !pharmItem.isOrderedFrom)
        .toList();
  }

// calculates the pharmacy closest to the given coordinates
  Pharmacy calculateClosestPharmacy() {
    Pharmacy closestPharmacy;
    if (pharmaciesNotOrderedFrom.length == 1) {
      closestPharmacy = pharmaciesNotOrderedFrom[0];
    } else {
      double closestPharmDis = getDistanceFromLatLonInKm(
          pharmaciesNotOrderedFrom[0].latitude,
          pharmaciesNotOrderedFrom[1].longitude);
      closestPharmacy = pharmaciesNotOrderedFrom[0];
      for (var pharm in pharmaciesNotOrderedFrom) {
        double dis = getDistanceFromLatLonInKm(pharm.latitude, pharm.longitude);
        if (dis < closestPharmDis) {
          closestPharmacy = pharm;
        }
      }
    }
    return closestPharmacy;
  }

// method to calculate distance between two given coordinates
  double getDistanceFromLatLonInKm(lat2, lon2) {
    double lat1 = 37.48771670017411;
    double lon1 = -122.22652739630438;
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  double deg2rad(deg) {
    return deg * (math.pi / 180);
  }
}
