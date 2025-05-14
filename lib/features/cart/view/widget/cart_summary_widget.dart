import 'package:flutter/material.dart';

class CartSummaryWidget extends StatelessWidget {
  final String total;

  const CartSummaryWidget({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          summaryRow('Subtotal', total),
          summaryRow('Shipping', 'Free Delivery'),
          summaryRow('Tax', 'Included'),
          const SizedBox(height: 10),
          summaryRow('Total', total, isTotal: true),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget summaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 16,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 16,
                  color: isTotal ? Colors.pink : null,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
