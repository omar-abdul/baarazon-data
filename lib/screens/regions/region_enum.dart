import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

Future<void> saveEnumAsIndex(Regions region) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('RegionsIndex', region.index);
}

Future<Regions?> getEnumFromIndex() async {
  final prefs = await SharedPreferences.getInstance();
  int? regionIndex = prefs.getInt('RegionsIndex');

  if (regionIndex != null && regionIndex < Regions.values.length) {
    return Regions.values[regionIndex];
  }
  return Regions.puntland; // or a default value
}
