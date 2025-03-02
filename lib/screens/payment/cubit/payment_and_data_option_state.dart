part of 'payment_and_data_option_cubit.dart';

@immutable
sealed class PaymentAndDataOptionState {
  final int currentIndex;
  final MapEntry<PaymentOptions, PaymentOption>? paymentOption;

  const PaymentAndDataOptionState({
    required this.currentIndex,
    this.paymentOption,
  });
}

final class PaymentAndDataOptionInitial extends PaymentAndDataOptionState {
  const PaymentAndDataOptionInitial()
      : super(currentIndex: 0, paymentOption: null);
}

final class SelectedPaymentAndDataOption extends PaymentAndDataOptionState {
  const SelectedPaymentAndDataOption({
    required super.currentIndex,
    required MapEntry<PaymentOptions, PaymentOption> super.paymentOption,
  });
}

final class ChangePaymentAndDataOption extends PaymentAndDataOptionState {
  const ChangePaymentAndDataOption({
    super.currentIndex = 0,
    required MapEntry<PaymentOptions, PaymentOption> super.paymentOption,
  });
}
