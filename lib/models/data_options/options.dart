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
    }
  }
}

const Map<String, Set<PackageType>> providerPackageTypes = {
  'Somtel': {
    PackageType.prepaid,
    PackageType.unlimitedData,
    PackageType.daily,
    PackageType.weekly,
    PackageType.monthlyMudaysan,
    PackageType.monthlyXadaysan,
    PackageType.noExpiry,
  },
  'Amtel': {
    PackageType.tanaad,
    PackageType.unlimitedData,
  }
};

List<Option> generateSomtelOption(String region, PackageType type) {
  switch (region) {
    case 'Puntland':
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

    case 'Muqdisho':
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

    case 'Hargeisa':
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

    default:
      return [];
  }
}

List<Option> generateAmtelOption(String region, PackageType type) {
  switch (region) {
    case 'Puntland':
    case 'Muqdisho':
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
