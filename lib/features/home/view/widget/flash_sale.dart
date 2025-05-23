import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/presentation/all_books_screen.dart';
import 'package:bookstore_app/features/home/view/presentation/book_details.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/flash_sale_cubit/flash_sale_cubit.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/flash_sale_cubit/flash_sale_state.dart';
import 'package:bookstore_app/features/home/view/widget/recommended_view_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashSale extends StatelessWidget {
  const FlashSale({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlashSaleCubit()..getlimitBooks(),
      child: const FlashSaleBody(),
    );
  }
}

class FlashSaleBody extends StatelessWidget {
  const FlashSaleBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashSaleCubit, FlashSaleState>(
      builder: (context, state) {
        if (state is FlashSaleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FlashSaleError) {
          return Center(child: Text(state.message));
        } else if (state is FlashSaleSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Flash Sale',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllBooksScreen()),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward, color: Colors.pink),
                      label: const Text('See All',
                          style: TextStyle(color: Colors.pink)),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  return RecommendedViewItem(book: state.books[index]);
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class FlashSaleItem extends StatelessWidget {
  const FlashSaleItem({super.key, required this.book});

  final Books book;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = '${book.image ?? ''}';

    return InkWell(
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(bookId: book.id!),
      ),
    );
  },
  
      child: Container(
        padding: const EdgeInsets.all(12.0),
        color: Colors.white,
        height: 124,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 555 / 830,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(book.title ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Author: ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: book.author ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.attach_money,
                              color: Colors.black87, size: 18),
                          Text(
                            book.priceAfterDiscount ?? book.price ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined,
                                color: Colors.pinkAccent),
                            onPressed: () {
                              // TODO: Add to cart
                            },
                          ),
                          ClipOval(
                            child: Container(
                              color: Colors.white,
                              width: 40,
                              height: 40,
                              child: IconButton(
                                icon: const Icon(Icons.favorite_border,
                                    color: Colors.pinkAccent),
                                onPressed: () {
                                  // TODO: Add to wishlist
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
