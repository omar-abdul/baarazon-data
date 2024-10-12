import '../../constants.dart';
import '../../route/screen_exports.dart';

const Map<InternetProviders, InternetProvider> internetProviderMap = {
  InternetProviders.golis: InternetProvider(
      isAvailable: true,
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
