const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

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
    }
  }
}

final Map<Regions, bool> regionEnabled = {
  Regions.puntland: true,
  Regions.somaliland: false,
  Regions.southSomalia: false
};

const apiUrl = 'http://10.0.2.2:3000/api/v1';
// const apiUrl = 'http://192.168.208.110:5000/api/v1';
