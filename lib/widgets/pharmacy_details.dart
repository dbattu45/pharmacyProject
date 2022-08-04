import 'package:flutter/material.dart';
import 'package:pharmacies2/providers/medication.dart';
import 'package:pharmacies2/providers/pharmacy.dart';

class PharmacyDetails extends StatefulWidget {
  const PharmacyDetails({Key? key, required this.currentPharmacy})
      : super(key: key);

  final Pharmacy currentPharmacy;

  @override
  State<PharmacyDetails> createState() => _PharmacyDetailsState();
}

class _PharmacyDetailsState extends State<PharmacyDetails> {
  Widget pharmacyDetailItem(String text) {
    return Wrap(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 35, 25, 0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pharmacyDetailItem('Name : ${widget.currentPharmacy.name}'),
          pharmacyDetailItem('Address : ${widget.currentPharmacy.address}'),
          if (widget.currentPharmacy.phoneNo != null)
            pharmacyDetailItem('Phone no : ${widget.currentPharmacy.phoneNo}'),
          if (widget.currentPharmacy.hours != null)
            pharmacyDetailItem(
                'Pharmacy Hours : ${widget.currentPharmacy.hours}'),
          if (widget.currentPharmacy.medications.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(25, 50, 25, 0),
                  child: Text('Medications ordered at this pharmacy are :',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                ...widget.currentPharmacy.medications.map(
                  (Medication m) {
                    return Wrap(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                            child: Text(m.name))
                      ],
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
