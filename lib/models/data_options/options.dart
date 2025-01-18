import 'package:baarazon_data/constants.dart';

import 'option_export.dart';

class Option {
  final String name;
  final double amount;
  final String duration;
  final String title;
  final String id; //package id e.g amtel_tanaad_1
  final PackageType packageType;
  final String currency;

  Option({
    required this.name,
    required this.amount,
    required this.duration,
    required this.title,
    required this.id,
    required this.packageType,
    this.currency = 'USD',
  });
}

enum PackageType {
  prepaid,
  unlimitedData,
  daily,
  weekly,
  monthlyMudaysan,
  monthlyXadaysan,
  tanaad,
  noExpiry,
  monthly,
  none
}

extension PackageTypeExtension on PackageType {
  String get displayName {
    switch (this) {
      case PackageType.prepaid:
        return 'Prepaid';
      case PackageType.unlimitedData:
        return 'Unlimited Data';
      case PackageType.daily:
        return 'Daily';
      case PackageType.weekly:
        return 'Weekly';
      case PackageType.monthlyMudaysan:
        return 'Monthly Mudaysan';
      case PackageType.monthlyXadaysan:
        return 'Monthly Xadaysan';
      case PackageType.tanaad:
        return 'Tanaad';
      case PackageType.noExpiry:
        return 'No Expiry';
      case PackageType.monthly:
        return 'Monthly';
      case PackageType.none:
        return 'None';
    }
  }
}

const Map<InternetProviders, Map<Regions, Set<PackageType>>>
    providerPackageTypes = {
  InternetProviders.somtel: {
    Regions.puntland: {
      PackageType.prepaid,
      PackageType.unlimitedData,
      PackageType.daily,
      PackageType.weekly,
      PackageType.monthlyMudaysan,
      PackageType.monthlyXadaysan,
    },
    Regions.southSomalia: {
      PackageType.prepaid,
      PackageType.unlimitedData,
      PackageType.daily,
      PackageType.noExpiry,
    },
    Regions.somaliland: {
      PackageType.unlimitedData,
      PackageType.daily,
      PackageType.noExpiry,
    },
  },
  InternetProviders.amtel: {
    Regions.puntland: {
      PackageType.tanaad,
      PackageType.unlimitedData,
    },
    Regions.southSomalia: {
      PackageType.tanaad,
      PackageType.unlimitedData,
    },
  },
  InternetProviders.golis: {
    Regions.puntland: {
      PackageType.prepaid,
      PackageType.unlimitedData,
      PackageType.daily,
      PackageType.weekly,
      PackageType.monthly,
      PackageType.monthlyXadaysan,
    }
  }
};

List<Option> generateGolisOption(Regions region, PackageType type) {
  switch (region) {
    case Regions.puntland:
      switch (type) {
        case PackageType.prepaid:
          return golisPrepaid;
        case PackageType.unlimitedData:
          return golisUnlimitedData;
        case PackageType.daily:
          return golisDaily;
        case PackageType.weekly:
          return golisWeekly;
        case PackageType.monthly:
          return golisMonthly;
        case PackageType.monthlyXadaysan:
          return golisMonthlyXadaysan;
        default:
          return [];
      }
    default:
      return [];
  }
}

List<Option> generateSomtelOption(Regions region, PackageType type) {
  switch (region) {
    case Regions.puntland:
      switch (type) {
        case PackageType.prepaid:
          return puntlandPrepaid;
        case PackageType.unlimitedData:
          return puntlandUnlimitedDataPackage;
        case PackageType.daily:
          return puntlandDailyInternetPackage;
        case PackageType.weekly:
          return puntlandWeeklyInternetPackage;
        case PackageType.monthlyMudaysan:
          return puntlandMonthlyMudaysanInternetPackage;
        case PackageType.monthlyXadaysan:
          return puntlandMonthlyXadaysanInternetPackage;
        default:
          return [];
      }

    case Regions.southSomalia:
      switch (type) {
        case PackageType.prepaid:
          return muqdishoPrepaid;
        case PackageType.unlimitedData:
          return muqdishoUnlimitedDataPackage;
        case PackageType.daily:
          return muqdishoDailyInternetPackage;
        case PackageType.noExpiry:
          return muqdishoNoExpiryInternetPackage;
        default:
          return [];
      }

    case Regions.somaliland:
      switch (type) {
        case PackageType.unlimitedData:
          return hargeisaUnlimitedDataPackage;
        case PackageType.daily:
          return hargeisaDailyInternetPackage;
        case PackageType.noExpiry:
          return hargeisaNoExpiryInternetPackage;
        default:
          return [];
      }
  }
}

List<Option> generateAmtelOption(Regions region, PackageType type) {
  switch (region) {
    case Regions.puntland:
    case Regions.southSomalia:
      switch (type) {
        case PackageType.tanaad:
          return amtelTanaadPackage;
        case PackageType.unlimitedData:
          return amtelUnlimitedDataPackage;
        default:
          return [];
      }
    default:
      return [];
  }
}

List<Option> generateOption(
    InternetProviders provider, Regions region, PackageType type) {
  if (provider == InternetProviders.somtel) {
    return generateSomtelOption(region, type);
  } else if (provider == InternetProviders.amtel) {
    return generateAmtelOption(region, type);
  } else if (provider == InternetProviders.golis) {
    return generateGolisOption(region, type);
  } else {
    return [];
  }
}
