import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

class CountryService {
  Future<CountryWithPhoneCode> getSomaliaCountryCode() async {
    final regions = await getAllSupportedRegions();
    final region = regions['SO']!;
    return region;
  }
}
