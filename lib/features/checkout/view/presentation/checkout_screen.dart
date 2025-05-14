import 'package:bookstore_app/features/cart/view/widget/cart_summary_widget.dart';
import 'package:bookstore_app/features/checkout/view/widget/cart_item_widget.dart';
import 'package:bookstore_app/features/checkout/view/widget/payment_option_widget.dart';
import 'package:bookstore_app/features/checkout/view/view_models/checkout_cubit.dart';
import 'package:bookstore_app/features/checkout/view/view_models/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Checkout'),
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order placed successfully')),
            );
          } else if (state is CheckoutErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CheckoutLoadedState) {
            var cart = state.cart;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (var book in cart.cartBooks)
                    CartItemWidget(
                      imageUrl: book.bookImage,
                      title: book.bookTitle,
                      author: 'Unknown',
                      asin: book.bookId.toString(),
                      price: double.parse(book.bookPriceAfterDiscount),
                      quantity: book.bookQuantity,
                      onRemove: () {},
                      onMoveToWishlist: () {},
                      onIncrease: () {},
                      onDecrease: () {},
                    ),
                  const SizedBox(height: 16),
                  CartSummaryWidget(total: cart.total),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Payment Method",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      PaymentOption(title: "Online payment"),
                      PaymentOption(title: "Cash on delivery", selected: true),
                      PaymentOption(title: "POS on delivery"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Add note",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        context.read<CheckoutCubit>().placeOrder();
                      },
                      child: const Text("Confirm order"),
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
