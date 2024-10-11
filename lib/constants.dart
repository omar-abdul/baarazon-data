import 'package:baarazon_data/route/route_constants.dart';

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);
// const Map<String, List<dynamic>> internetProviders = {
//   'Golis ': ['assets/company_logo/golis.png', golisOptionsScreenRoute, false],
//   'Somtel': ['assets/company_logo/somtel.jpg', somtelOptionsScreenRoute, true],
//   'Amtel': ['assets/company_logo/amtelkom.png', amtelOptionsScreenRoute, true],
//   'Hormuud': [
//     'assets/company_logo/hormuud.jpg',
//     amtelOptionsScreenRoute,
//     false
//   ],
// };

const Map<InternetProviders, InternetProvider> internetProviderMap = {
  InternetProviders.golis: InternetProvider(
      isAvailable: false,
      logoPath: 'assets/company_logo/Golis.png',
      name: 'Golis',
      regions: [Regions.puntland],
      route: golisOptionsScreenRoute),
  InternetProviders.somtel: InternetProvider(
      isAvailable: true,
      logoPath: 'assets/company_logo/Somtel.png',
      name: 'Somtel',
      regions: [Regions.puntland, Regions.southSomalia, Regions.somaliland],
      route: somtelOptionsScreenRoute),
  InternetProviders.amtel: InternetProvider(
      isAvailable: true,
      logoPath: 'assets/company_logo/amtel.png',
      name: 'Amtel',
      regions: [Regions.puntland, Regions.southSomalia],
      route: amtelOptionsScreenRoute),
  InternetProviders.hormuud: InternetProvider(
      isAvailable: false,
      logoPath: 'assets/company_logo/Hormuud.png',
      name: 'Hormuud',
      regions: [Regions.southSomalia],
      route: amtelOptionsScreenRoute),
  InternetProviders.durdur: InternetProvider(
      isAvailable: false,
      logoPath: 'assets/company_logo/Durdur.png',
      name: 'Durdur',
      regions: [Regions.puntland],
      route: ''),
  InternetProviders.somlink: InternetProvider(
    isAvailable: false,
    logoPath: 'assets/company_logo/Somlink.png',
    name: 'Somlink',
    regions: [Regions.southSomalia],
    route: '',
  ),
  InternetProviders.somnet: InternetProvider(
      name: 'Somnet',
      logoPath: 'assets/company_logo/Somnet.png',
      route: '',
      isAvailable: false,
      regions: [Regions.southSomalia]),
  InternetProviders.telesom: InternetProvider(
      name: 'Telesom',
      logoPath: 'assets/company_logo/Telesom.png',
      route: '',
      isAvailable: false,
      regions: [Regions.somaliland])
};

enum InternetProviders {
  golis,
  somtel,
  amtel,
  hormuud,
  durdur,
  somlink,
  somnet,
  telesom
}

class InternetProvider {
  final String name;
  final String logoPath;
  final String route;
  final bool isAvailable;
  final List<Regions> regions;
  const InternetProvider(
      {required this.name,
      required this.logoPath,
      required this.route,
      required this.isAvailable,
      required this.regions});
}

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
