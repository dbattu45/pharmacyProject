import 'package:flutter/material.dart';
import '../providers/medication.dart';
import '../providers/pharmacy.dart';

class MedicationItem extends StatefulWidget {
  const MedicationItem({Key? key, required this.med, required this.pharmacy})
      : super(key: key);

  final Medication med;
  final Pharmacy pharmacy;
  @override
  State<MedicationItem> createState() => _MedicationItemState();
}

class _MedicationItemState extends State<MedicationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.med.name,
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (!widget.pharmacy.medications.contains(widget.med)) {
                        widget.pharmacy.medications.add(widget.med);
                      }
                    }),
              ),
              ElevatedButton(
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    widget.pharmacy.medications.remove(widget.med);
                  }),
            ],
          )
        ],
      ),
    );
  }
}
