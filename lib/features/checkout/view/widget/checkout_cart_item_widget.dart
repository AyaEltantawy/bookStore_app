import 'package:bookstore_app/features/cart/view/view_model/cart_cubit.dart';
import 'package:bookstore_app/features/checkout/view/view_models/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/data/model/cart_model.dart';

class CheckoutCartItemWidget extends StatelessWidget {
  final CartBook book;
  const CheckoutCartItemWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CheckoutCubit>();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image.network(
            //   book.image,
            //   width: 80,
            //   height: 20,
            //   // fit: BoxFit.cover,
            // ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('${book.priceAfterDiscount} EGP',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  Text('Quantity: ${book.quantity}',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (book.quantity > 1) {
                      cartCubit.updateQuantity(book.id, book.quantity - 1);
                    }
                  },
                ),
                Text(book.quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    cartCubit.updateQuantity(book.id, book.quantity + 1);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
