import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacies2/home_page.dart';
import 'package:pharmacies2/medication_item.dart';
import 'package:pharmacies2/providers/medication.dart';
import 'package:pharmacies2/providers/pharmacy.dart';
import 'package:provider/provider.dart';
import 'providers/pharmacies.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late Pharmacy closestPharmacy;
  List<Medication> medications = <Medication>[];
  @override
  void initState() {
    super.initState();
    fetchMedications();
    Future<void>.microtask(
      () {
        closestPharmacy = Provider.of<Pharmacies>(context, listen: false)
            .calculateClosestPharmacy();
      },
    );
  }

  Future<void> fetchMedications() async {
    final response = await http.get(Uri.parse(
        'https://s3-us-west-2.amazonaws.com/assets.nimblerx.com/prod/medicationListFromNIH/medicationListFromNIH.txt'));
    if (response.statusCode == 200 || response.statusCode == 304) {
      // If the server did return a 200 or 304 OK response
      List<String> meds = response.body.split(',');
      for (var m in meds) {
        medications.add(Medication(name: m));
      }
      setState(() {});
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load pharmacy Details');
    }
  }

  onConfirmPress() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order details'),
        actions: [
          ElevatedButton(
            child: const Text(
              'Confirm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              closestPharmacy.isOrderedFrom = true;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return const HomePage();
                  },
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ...medications.map(
                  (Medication m) {
                    return MedicationItem(med: m, pharmacy: closestPharmacy);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
