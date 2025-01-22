import '../models/payment.dart';
import 'http_service.dart';
import 'preferences_service.dart';

class PaymentService {
  final _http = HttpService();

  Future<PaymentResponse> processPayment(PaymentRequest request) async {
    final token = await PreferencesService.getToken();
    final response = await _http.post<PaymentResponse, Map<String, dynamic>>(
      '/topup',
      body: request.toJson(),
      fromJson: (json) => PaymentResponse.fromJson(json),
      acceptedCodes: {200},
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }
}
