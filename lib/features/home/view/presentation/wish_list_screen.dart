import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/wish_list_cubit.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/wish_list_state.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WishListCubit()..fetchWishlist(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Wishlist'),
          centerTitle: true,
        ),
        body: WishListBody(),
      ),
    );
  }
}

class WishListBody extends StatelessWidget {
  const WishListBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishListCubit, WishListState>(
      builder: (context, state) {
        if (state is WishListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WishListSuccess) {
          if (state.books.isEmpty) {
            return const Center(child: Text('Wishlist is empty'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: state.books.length,
            itemBuilder: (context, index) {
              return WishListItem(book: state.books[index]);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          );
        } else if (state is WishListError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }
}

class WishListItem extends StatelessWidget {
  final Books book;

  const WishListItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.network(
            book.image ?? '',
            width: 98,
            height: 124,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 7),
                Text('Author: ${book.author ?? ''}'),
                const SizedBox(height: 15),
                const Text(
                  'Item out of stock',
                  style: TextStyle(color: Color(0xFFEB4335)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
