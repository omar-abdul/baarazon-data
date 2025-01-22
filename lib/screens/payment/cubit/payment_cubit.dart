import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/payment.dart';
import '../../../services/payment_service.dart' as ps;

enum PaymentStatus { initial, loading, success, failure }

class PaymentState {
  final PaymentStatus status;
  final String? error;
  final PaymentResponse? response;

  PaymentState({
    this.status = PaymentStatus.initial,
    this.error,
    this.response,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    String? error,
    PaymentResponse? response,
  }) {
    return PaymentState(
      status: status ?? this.status,
      error: error ?? this.error,
      response: response ?? this.response,
    );
  }
}

class PaymentCubit extends Cubit<PaymentState> {
  final ps.PaymentService _paymentService;

  PaymentCubit(this._paymentService) : super(PaymentState());

  Future<void> processPayment(PaymentRequest request) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    try {
      final response = await _paymentService.processPayment(request);
      emit(state.copyWith(
        status: PaymentStatus.success,
        response: response,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PaymentStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
