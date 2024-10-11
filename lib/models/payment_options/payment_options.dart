import 'package:baarazon_data/constants.dart';

enum PaymentOptions {
  sahal,
  edahab,
  premierBank,
  evc,
  zaad,
  myCash,
  cardDebitCredit
}

extension PaymentString on PaymentOptions {
  String get displayName {
    switch (this) {
      case PaymentOptions.sahal:
        return 'Sahal Golis';
      case PaymentOptions.edahab:
        return 'Edahab Somtel';
      case PaymentOptions.premierBank:
        return 'Premier Wallet';
      case PaymentOptions.evc:
        return 'EVC Plus';
      case PaymentOptions.zaad:
        return 'Zaad Telesom';
      case PaymentOptions.myCash:
        return 'MyCash Amtel';
      case PaymentOptions.cardDebitCredit:
        return 'Credit or Debit Card';
      default:
        return '';
    }
  }
}

const Map<PaymentOptions, PaymentOption> paymentOptions = {
  PaymentOptions.sahal: PaymentOption(
    region: [Regions.puntland],
    imageUrl: 'assets/payment_logos/Sahal.png',
  ),
  PaymentOptions.edahab: PaymentOption(
      region: [...Regions.values], imageUrl: 'assets/payment_logos/eDahab.png'),
  PaymentOptions.premierBank: PaymentOption(
      region: [...Regions.values], imageUrl: 'assets/payment_logos/Card.png'),
  PaymentOptions.evc: PaymentOption(
      region: [Regions.southSomalia], imageUrl: 'assets/payment_logos/EVC.png'),
  PaymentOptions.zaad: PaymentOption(
      region: [Regions.somaliland], imageUrl: 'assets/payment_logos/zaad.png'),
  PaymentOptions.myCash: PaymentOption(
      region: [Regions.puntland, Regions.southSomalia],
      imageUrl: 'assets/payment_logos/MyCash.png'),
  // PaymentOptions.cardDebitCredit:
  //     'https://logospng.org/wp-content/uploads/mastercard.jpg',
}; //payment options with image string

class PaymentOption {
  final List<Regions> region;
  final String imageUrl;

  const PaymentOption({required this.region, required this.imageUrl});
}
