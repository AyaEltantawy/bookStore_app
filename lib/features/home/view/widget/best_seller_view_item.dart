import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:flutter/material.dart';


class BestSellerViewItem extends StatelessWidget {
  final Books book;

  const BestSellerViewItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    debugPrint("Ganna Image: ");
    debugPrint(book.image);
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
               book.image??"",
              height: 180,
              width: 140,
              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
        // Print detailed error information
        print('=== Image Loading Error ===');
        print('Error: $error');
        print('Error Type: ${error.runtimeType}');
        print('Stack Trace: $stackTrace');
        print('========================');
        
                return Container(
              
                color: Colors.grey[300],
                height: 180,
                width: 140,
                child: const Icon(Icons.broken_image),
              );},
            ),
          ),
        
          
        ],
      ),
    );
  }
}
