class Transaction {
  final String serviceName;
  final double amount;
  final String status;
  final String? description;
  final String topupTo;

  Transaction({
    required this.serviceName,
    required this.amount,
    required this.status,
    this.description,
    required this.topupTo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      serviceName: json['services']['name'],
      amount: json['amount_paid'],
      status: json['status'],
      topupTo: json['topup_to'],
    );
  }
}
