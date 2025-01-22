import 'transaction.dart';

class PaymentRequest {
  final String payFrom;
  final String payProvider;
  final String topupTo;
  final int providerId;
  final PaymentService service;

  PaymentRequest({
    required this.payFrom,
    required this.payProvider,
    required this.topupTo,
    required this.providerId,
    required this.service,
  });

  Map<String, dynamic> toJson() => {
        'pay_from': payFrom,
        'pay_provider': payProvider,
        'topup_to': topupTo,
        'provider_id': providerId,
        'service': service.toJson(),
      };
}

class PaymentService {
  final int id;
  final double amount;

  PaymentService({
    required this.id,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
      };
}

class PaymentResponse {
  final String message;
  final Transaction transaction;

  PaymentResponse({
    required this.message,
    required this.transaction,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      message: json['message'],
      transaction: Transaction.fromJson(json['transaction']),
    );
  }
}
