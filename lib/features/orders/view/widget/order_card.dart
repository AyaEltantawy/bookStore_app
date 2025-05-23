import 'package:bookstore_app/features/order/order_details.dart';
import 'package:bookstore_app/features/orders/data/models/order.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text("Total: ${order.totalAmount}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: ${order.status}"),
            Text("Date: ${order.date}"),
            Text("Payment: ${order.paymentMethod}"),
          ],
        ),
      ),
    );
  }
}

