import 'package:baarazon_data/models/payment_options/payment_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

// import '../../../../models/data_options/options.dart';

part 'payment_and_data_option_state.dart';

class PaymentAndDataOptionCubit extends Cubit<PaymentAndDataOptionState> {
  PaymentAndDataOptionCubit() : super(const PaymentAndDataOptionInitial());

  void onSelectPayment(MapEntry<PaymentOptions, PaymentOption> entry) {
    emit(SelectedPaymentAndDataOption(
      currentIndex: 1,
      paymentOption: entry,
    ));
  }

  void changePayment() {
    emit(ChangePaymentAndDataOption(
      currentIndex: 0,
      paymentOption: state.paymentOption!,
    ));
  }
}
