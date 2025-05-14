import 'package:bookstore_app/features/order/order_details.dart';
import 'package:bookstore_app/features/orders/data/models/order.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  Widget buildStatusStepper(String status) {
    if (status != "In progress") return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(children: [
          const Icon(Icons.check_circle, color: Colors.pink),
          const Text("Order placed")
        ]),
        const Expanded(child: Divider(color: Colors.pink, thickness: 2)),
        Column(children: [
          const Icon(Icons.check_circle, color: Colors.pink),
          const Text("Shipping")
        ]),
        const Expanded(child: Divider(color: Colors.grey, thickness: 2)),
        Column(children: [
          const Icon(Icons.radio_button_unchecked, color: Colors.grey),
          const Text("Completed")
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.delete_outline, color: Colors.pink),
            ),
            Text("Order No. ${order.number}"),
            Text("Status: ${order.status}"),
            Text("Date: ${order.date}"),
            Text("Address: ${order.address}"),
            if (order.status == "In progress") const SizedBox(height: 12),
            buildStatusStepper(order.status),
            if (order.status != "In progress")
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OrderDetailsScreen()),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.pink),
                  label: const Text("View order detail",
                      style: TextStyle(color: Colors.pink)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
