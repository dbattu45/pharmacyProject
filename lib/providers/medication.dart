import 'package:flutter/foundation.dart';

// Medication model
class Medication with ChangeNotifier {
  final String name;

  Medication({required this.name});
}
