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
        title: 'Unlimited Data - 24/h',
        amount: 0.99,
        isPending: true,
        description: '1 day unlimited data plan'),
    Order(
        title: 'Prepaid - Unlimited Calls - 3 Days',
        amount: 0.22,
        isPending: false,
        description: 'Affordable prepaid call package for 3 days'),
    Order(
        title: 'Unlimited Data - 7 Days',
        amount: 2.47,
        isPending: false,
        description: 'Weekly unlimited data plan'),
    Order(
        title: 'Weekly Internet - 1.5GB',
        amount: 0.48,
        isPending: false,
        description: 'Weekly internet package with 1.5GB data'),
    Order(
        title: 'Monthly Internet - 25GB',
        amount: 4.60,
        isPending: true,
        description: 'Monthly internet plan with 25GB data'),
    Order(
        title: 'Prepaid - Unlimited Calls - 30 Days',
        amount: 4.45,
        isPending: false,
        description: 'Prepaid package for unlimited calls for 30 days'),
  ];

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
          ...orders.map((order) {
            return OrderCard(
              title: order.title,
              amount: order.amount,
              isPending: order.isPending,
              description: order.description,
            );
          }),
        ]),
      ),
    );
  }

  Future<void> _refresh() async {
    // Add refresh logic if necessary
  }
}
