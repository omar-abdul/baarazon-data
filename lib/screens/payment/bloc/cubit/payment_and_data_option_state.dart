part of 'payment_and_data_option_cubit.dart';

@immutable
sealed class PaymentAndDataOptionState {
  final Option? selectedOption;
  final int currentIndex;
  final MapEntry<PaymentOptions, PaymentOption>? paymentOption;
  const PaymentAndDataOptionState(
      {this.selectedOption,
      required this.currentIndex,
      required this.paymentOption});
}

final class PaymentAndDataOptionInitial extends PaymentAndDataOptionState {
  const PaymentAndDataOptionInitial()
      : super(selectedOption: null, currentIndex: 0, paymentOption: null);
}

final class NewPaymentAndDataState extends PaymentAndDataOptionState {
  const NewPaymentAndDataState(
      {required Option super.selectedOption,
      required super.currentIndex,
      required MapEntry<PaymentOptions, PaymentOption> super.paymentOption});
}
