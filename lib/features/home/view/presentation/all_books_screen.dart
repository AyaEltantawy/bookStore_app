import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/all_books_cubit.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/all_books_state.dart';

class AllBooksScreen extends StatelessWidget {
  const AllBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllBooksCubit()..fetchBooks(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text("All Books"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const AllBooksItem(),
      ),
    );
  }
}

class AllBooksItem extends StatelessWidget {
  const AllBooksItem({super.key});

  @override
  Widget build(BuildContext context) {
   
    return BlocBuilder<AllBooksCubit, AllBooksState>(
      builder: (context, state) {
        if (state is AllBooksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllBooksError) {
          return Center(child: Text(state.message));
        } else if (state is AllBooksSuccess) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: state.books.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                 final String imageUrl = 'http://127.0.0.1:8000/upload/books/${'book.image'}';
                final book = state.books[index];
                return _buildBookCard(book);
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildBookCard(BookModel book) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                 book.image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Author: ${book.author}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.attach_money, size: 16, color: Colors.black),
              Text(
                book.priceAfterDiscount ?? book.price,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.shopping_cart_outlined,
                  size: 18, color: Colors.pink),
            ],
          ),
        ],
      ),
    );
  }
}
