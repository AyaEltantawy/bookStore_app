import 'package:bookstore_app/features/home/view/view_model/cubit/best_seller_cubit_cubit.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/best_seller_cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/features/home/view/widget/best_seller_view_item.dart';


class BestSeller extends StatelessWidget {
  const BestSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BestSellerCubit()..fetchBestSellerBooks(),
      child: BestSellerBody(),
    );
  }
}

class BestSellerBody extends StatelessWidget {
  const BestSellerBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BestSellerCubit, BestSellerState>(
      builder: (context, state) {
        if (state is BestSellerLoading || state is BestSellerInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BestSellerError) {
          return Center(child: Text(state.message));
        } else if (state is BestSellerSuccess) {
         
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                return BestSellerViewItem(book: state.books[index]);
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
