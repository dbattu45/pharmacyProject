import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pharmacies2/pharmacy_details.dart';
import 'package:pharmacies2/providers/pharmacy.dart';

class PharmacyItem extends StatelessWidget {
  const PharmacyItem({Key? key, required this.pharmacy}) : super(key: key);
  final Pharmacy pharmacy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: pharmacy.name,
              style: const TextStyle(
                color: Colors.black,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return PharmacyDetails(currentPharmacy: pharmacy);
                      },
                    ),
                  );
                },
            ),
          ),
          if (pharmacy.isOrderedFrom)
            const Icon(
              Icons.check_rounded,
              color: Colors.green,
              size: 30.0,
            ),
        ],
      ),
    );
  }
}
