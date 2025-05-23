import 'package:bookstore_app/core/icons/wish_list_icon.dart';
import 'package:bookstore_app/features/home/view/presentation/all_books_screen.dart';
import 'package:bookstore_app/features/home/view/view_model/home_cubit.dart';
import 'package:bookstore_app/features/home/view/view_model/home_state.dart';
import 'package:bookstore_app/features/home/view/widget/flash_sale.dart';
import 'package:bookstore_app/features/home/view/widget/recommended_view_item.dart';
import 'package:bookstore_app/features/home/view/widget/best_seller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getlimitBooks(),     child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
          actions: const [WishListIcon()],
        ),
        backgroundColor: Colors.grey[200],
        body: const HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            const SectionTitle(title: ' BestSeller'),
            const SliverToBoxAdapter(child: BestSeller()),
            const RecommendedSection(),
            const BooksListSection(),
            const SliverToBoxAdapter(child:FlashSale() ),
            // SliverList(
            
            //   delegate: SliverChildBuilderDelegate(
            //     (context, index) => const WishListScreen(),
            //     childCount: 2,
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommended for you',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllBooksScreen()),
                );
              },
              icon: const Icon(Icons.arrow_forward, color: Colors.pink),
              label: const Text('See All', style: TextStyle(color: Colors.pink)),
            ),
          ],
        ),
      ),
    );
  }
}

class BooksListSection extends StatelessWidget {
  const BooksListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeCubit>().state;

    if (state is GetLimitBooksLoadingState) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (state is GetLimitBooksSucessState) {
      final books = context.read<HomeCubit>().books!;
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: RecommendedViewItem(book: books[index]),
            );
          },
          childCount: books.length,
        ),
      );
    } else {
      return const SliverToBoxAdapter(
        child: Center(child: Text('Something went wrong')),
      );
    }
  }
}