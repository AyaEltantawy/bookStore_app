import 'package:bookstore_app/features/cart/view/view_model/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/cart_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartBook book;
  const CartItemWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Uncomment when image is available
            // Image.network(
            //   book.image,
            //   width: 80,
            //   height: 80,
            //   fit: BoxFit.cover,
            // ),
            const SizedBox(width: 12),

            /// Expanded content area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Prevent long titles from overflowing
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${book.price} EGP',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Quantity: ${book.quantity}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// Quantity controls
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // here I will put inkell to put delete cart func
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (book.quantity > 1) {
                      cartCubit.updateQuantity(book.id, book.quantity - 1);
                    }
                  },
                ),
                Text(book.quantity.toString()),
                // here I will put inkell to add cart func
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    cartCubit.updateQuantity(book.id, book.quantity + 1);
                  },
                )
                ,

                InkWell(onTap: (){cartCubit.deleteCartProduct(context,book.id);},
                    child: Icon(Icons.delete,color: Colors.red,))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
