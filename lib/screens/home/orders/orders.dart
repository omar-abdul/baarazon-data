import 'package:flutter/material.dart';

import '../../../logger.dart';
import '../../../models/transaction.dart';
import '../../../services/transaction_service.dart';
import 'components/order_card.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final _transactionService = TransactionService();
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _transactionService.getTransactions();
      logger.d({'transactions': data});
      if (mounted) {
        setState(() {
          transactions = data;
        });
      }
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () async {
                  await _refresh();
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...transactions.map((transaction) {
            return OrderCard(
              name: transaction.serviceName,
              amount: transaction.amount,
              status: transaction.status,
              description: transaction.topupTo,
            );
          }),
        ]),
      ),
    );
  }

  Future<void> _refresh() async {
    await _loadData();
  }
}
