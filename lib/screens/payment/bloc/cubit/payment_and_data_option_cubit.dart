import 'package:baarazon_data/models/payment_options/payment_options.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../models/data_options/options.dart';

part 'payment_and_data_option_state.dart';

class PaymentAndDataOptionCubit extends Cubit<PaymentAndDataOptionState> {
  // PaymentAndDataOptionState? _previousState;
  PaymentAndDataOptionCubit() : super(const PaymentAndDataOptionInitial());

  void onSelectPayment(
      Option option, MapEntry<PaymentOptions, PaymentOption> entry) {
    emit(NewPaymentAndDataState(
        currentIndex: 1, selectedOption: option, paymentOption: entry));
  }

  void changePayment() {
    emit(NewPaymentAndDataState(
        selectedOption: state.selectedOption!,
        currentIndex: 0,
        paymentOption: state.paymentOption!));
  }
}
