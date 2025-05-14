import 'package:flutter/material.dart';

class PaymentOption extends StatelessWidget {
  final String title;
  final bool selected;

  const PaymentOption({super.key, required this.title, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: selected ? Colors.pink : Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: selected ? Colors.pink.shade50 : null,
      ),
      child: ListTile(
        leading: Radio(
          value: title,
          groupValue: selected ? title : null,
          onChanged: (_) {},
        ),
        title: Text(title),
      ),
    );
  }
}
