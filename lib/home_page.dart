import 'package:flutter/material.dart';
import 'package:pharmacies2/order_details.dart';
import 'package:pharmacies2/pharmacy_item.dart';
import 'package:pharmacies2/providers/pharmacies.dart';
import 'package:pharmacies2/providers/pharmacy.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pharmacy>? pharmacies;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<Pharmacy> allPharmacies =
        await Provider.of<Pharmacies>(context).allPharmacies;

    if (mounted) {
      setState(
        () {
          pharmacies = allPharmacies;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacies'),
      ),
      body: pharmacies != null
          ? Column(
              children: [
                // Display the ordering button and list of pharmacies only once we have the list.
                // Display loading text until then
                ...pharmacies!.map(
                  (Pharmacy p) {
                    return PharmacyItem(pharmacy: p);
                  },
                ),
                // Display the ordering button only when we have at least one pharmacy from which we haven't ordered
                if (Provider.of<Pharmacies>(context)
                    .pharmaciesNotOrderedFrom
                    .isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal:5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          child:  Text(
                              'Order Meds from ${Provider.of<Pharmacies>(context).calculateClosestPharmacy().name}'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return const OrderDetails();
                                },
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
              ],
            )
          : const Center(
              child: Text(
                'Pharmacies are being loaded',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
