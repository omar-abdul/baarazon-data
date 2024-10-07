import 'package:baarazon_data/screens/home/orders/components/order_card.dart';
import 'package:flutter/material.dart';

class Order {
  final String title;
  final double amount;
  final bool isPending;
  final String? description;

  Order(
      {required this.title,
      required this.amount,
      required this.isPending,
      this.description});
}

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final List<Order> orders = [
    Order(
        title: 'First', amount: 10, isPending: true, description: 'Small text'),
    Order(title: 'Second', amount: 10, isPending: false),
    Order(title: 'Third', amount: 10, isPending: false),
    Order(title: 'Fourth', amount: 10, isPending: false),
    Order(title: 'Fifth', amount: 10, isPending: false),
    Order(
      title: 'Sixth',
      amount: 10,
      isPending: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                  icon: const Icon(Icons.refresh)),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) => OrderCard(
                title: orders[index].title,
                amount: orders[index].amount,
                isPending: orders[index].isPending,
                description: orders[index].description,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {}
}
