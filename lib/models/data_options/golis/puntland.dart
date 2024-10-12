// Prepaid options for Golis
import '../options.dart';

List<Option> golisPrepaid = [
  Option(
      title: 'Prepaid',
      name: '120M',
      amount: 0.25,
      duration: '24/h',
      id: 'golis_prepaid_1',
      packageType: PackageType.prepaid),
  Option(
      title: 'Prepaid',
      name: '1000M',
      amount: 2,
      duration: '7 days',
      id: 'golis_prepaid_2',
      packageType: PackageType.prepaid),
  Option(
      title: 'Prepaid',
      name: '2000M',
      amount: 3,
      duration: '7 days',
      id: 'golis_prepaid_3',
      packageType: PackageType.prepaid),
  Option(
      title: 'Prepaid',
      name: 'Unlimited',
      amount: 7,
      duration: '30 days',
      id: 'golis_prepaid_4',
      packageType: PackageType.prepaid),
];

// Unlimited Data options for Golis
List<Option> golisUnlimitedData = [
  Option(
      title: 'Internet',
      name: 'Unlimited Data',
      amount: 1,
      duration: '24/h',
      id: 'golis_unlimited_1',
      packageType: PackageType.unlimitedData),
  Option(
      title: 'Internet',
      name: 'Unlimited Data',
      amount: 5,
      duration: '7 days',
      id: 'golis_unlimited_2',
      packageType: PackageType.unlimitedData),
  Option(
      title: 'Internet',
      name: 'Unlimited Data',
      amount: 20,
      duration: '30 days',
      id: 'golis_unlimited_3',
      packageType: PackageType.unlimitedData),
  Option(
      title: 'Internet',
      name: 'Unlimited Data + Call',
      amount: 25,
      duration: '30 days',
      id: 'golis_unlimited_4',
      packageType: PackageType.unlimitedData),
];

// Daily packages for Golis
List<Option> golisDaily = [
  Option(
      title: 'Internet',
      name: '500MB',
      amount: 0.25,
      duration: '24/h',
      id: 'golis_daily_1',
      packageType: PackageType.daily),
  Option(
      title: 'Internet',
      name: '5GB',
      amount: 0.5,
      duration: '24/h',
      id: 'golis_daily_2',
      packageType: PackageType.daily),
];

// Weekly packages for Golis
List<Option> golisWeekly = [
  Option(
      title: 'Internet',
      name: '10GB',
      amount: 2,
      duration: '7 days',
      id: 'golis_weekly_1',
      packageType: PackageType.weekly),
  Option(
      title: 'Internet',
      name: '50GB',
      amount: 3,
      duration: '7 days',
      id: 'golis_weekly_2',
      packageType: PackageType.weekly),
];

// Monthly packages for Golis
List<Option> golisMonthly = [
  Option(
      title: 'Internet',
      name: '20GB',
      amount: 5,
      duration: '30 days',
      id: 'golis_monthly_1',
      packageType: PackageType.monthly),
  Option(
      title: 'Internet',
      name: '50GB',
      amount: 10,
      duration: '30 days',
      id: 'golis_monthly_2',
      packageType: PackageType.monthly),
];

// Monthly (Xadaysan) packages for Golis
List<Option> golisMonthlyXadaysan = [
  Option(
      title: 'Xadaysan',
      name: '45GB',
      amount: 10,
      duration: '30 days',
      id: 'golis_xadaysan_1',
      packageType: PackageType.monthlyXadaysan),
  Option(
      title: 'Xadaysan',
      name: '81GB',
      amount: 15,
      duration: '30 days',
      id: 'golis_xadaysan_2',
      packageType: PackageType.monthlyXadaysan),
];
