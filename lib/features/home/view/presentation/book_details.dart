import 'package:bookstore_app/features/home/view/view_model/cubit/book_details_cubit.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/book_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailsScreen extends StatelessWidget {
  final int bookId;

  const BookDetailsScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookDetailsCubit()..fetchBookDetails(bookId),
      child: BlocBuilder<BookDetailsCubit, BookDetailsState>(
        builder: (context, state) {
          if (state is BookDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookDetailsSuccess) {
            final book = state.book; // الوصول مباشرة إلى الكتاب

            if (book == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Book Details')),
                body: const Center(child: Text('No details available for this book')),
              );
            }

          

            return Scaffold(
              appBar: AppBar(title: const Text('Book Details')),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book.image??"",
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      book.title ?? 'No title available',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Author: ${book.author ?? 'Unknown'}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, size: 18),
                        Text(
                          book.priceAfterDiscount ?? book.price ?? '0',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (book.priceAfterDiscount != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            book.price ?? '0',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.pink,
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        ],
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.description ?? 'No description available',
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () {
                            // TODO: Add to cart functionality
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {
                            // TODO: Add to wishlist functionality
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (state is BookDetailsError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Book Details')),
              body: Center(child: Text(state.message)),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
