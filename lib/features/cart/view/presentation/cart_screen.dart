import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/cart_cubit.dart';
import '../view_model/cart_state.dart';
import '../widget/cart_checkout_button.dart';
import '../widget/cart_item_widget.dart';
// import '../widget/cart_summary_widget.dart'; // Uncomment if you want to use this

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoadedState) {
            final cart = state.cart;
            if (cart.cartBooks.isEmpty) {
              return const Center(
                child: Text(
                  'No items in cart ,add to continue',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.cartBooks.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) =>
                        CartItemWidget(book: cart.cartBooks[index]),
                  ),
                ),
                // Uncomment the following line if you want to show the summary
                // CartSummaryWidget(total: cart.total),

                CartCheckoutButton(),
              ],
            );
          } else if (state is CartErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
