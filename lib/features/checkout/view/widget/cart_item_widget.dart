import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String asin;
  final double price;
  final int quantity;
  final Function() onRemove;
  final Function() onMoveToWishlist;
  final Function() onIncrease;
  final Function() onDecrease;

  const CartItemWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.asin,
    required this.price,
    required this.quantity,
    required this.onRemove,
    required this.onMoveToWishlist,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 100,
            width: 70,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Author: $author'),
                Text('ASIN: $asin'),
                const SizedBox(height: 8),
                Text(
                  '\$$price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.delete_outline),
                          label: const Text("Remove"),
                          onPressed: onRemove,
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.favorite_border),
                          label: const Text("Move to wishlist"),
                          onPressed: onMoveToWishlist,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: onDecrease,
                        ),
                        Text("$quantity"),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: onIncrease,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
