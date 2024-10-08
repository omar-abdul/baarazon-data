import 'package:baarazon_data/route/route_constants.dart';

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);
const Map<String, List<String>> internetProviders = {
  'Golis': ['assets/company_logo/golis.png', golisOptionsScreenRoute],
  'Somtel': ['assets/company_logo/somtel.jpg', somtelOptionsScreenRoute],
  'Amtel': ['assets/company_logo/amtelkom.png', amtelOptionsScreenRoute],
  'Hormuud': ['assets/company_logo/hormuud.jpg', amtelOptionsScreenRoute],
};

enum Regions { puntland, somaliland, southSomalia }

extension RegionExtension on Regions {
  String get displayName {
    switch (this) {
      case Regions.puntland:
        return 'Puntland';
      case Regions.somaliland:
        return 'Somaliland';
      case Regions.southSomalia:
        return 'South Somalia';
      default:
        return '';
    }
  }
}

final Map<Regions, bool> regionEnabled = {
  Regions.puntland: true,
  Regions.somaliland: false,
  Regions.southSomalia: false
};
