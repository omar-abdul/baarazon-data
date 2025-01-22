import '../logger.dart';
import '../models/transaction.dart';
import '../services/preferences_service.dart';
import 'http_service.dart';

class TransactionService {
  final _http = HttpService();

  Future<List<Transaction>> getTransactions() async {
    final token = await PreferencesService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await _http.get<List<Transaction>, Map<String, dynamic>>(
      '/my_transactions',
      headers: {
        'Authorization': 'Bearer $token',
      },
      fromJson: (json) {
        final List<dynamic> data = json as List<dynamic>;
        return data.map((item) => Transaction.fromJson(item)).toList();
      },
      acceptedCodes: {200},
    );

    return response;
  }
}
