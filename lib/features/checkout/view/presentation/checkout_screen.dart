import 'package:bookstore_app/core/magic_router/magic_router.dart';
import 'package:bookstore_app/features/checkout/view/widget/checkout_cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/features/checkout/view/view_models/checkout_cubit.dart';
import 'package:bookstore_app/features/checkout/view/view_models/checkout_state.dart';
import 'package:bookstore_app/features/cart/view/widget/cart_summary_widget.dart';
import 'package:bookstore_app/features/checkout/view/widget/payment_option_widget.dart';
import '../../../orders/view/presentation/order_history_screen.dart';

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
              SnackBar(content: Text(state.message)),
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
            final cart = state.cart;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: ListView.separated(
                      itemCount: cart.cartBooks.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) => CheckoutCartItemWidget(
                        book: cart.cartBooks[index],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CartSummaryWidget(total: cart.total),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      PaymentOption(title: "Cash on delivery", selected: true),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Add note",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                        context.read<CheckoutCubit>().placeOrder(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderHistoryPage(),
                          ),
                        );
                      },
                      child: const Text("Confirm order"),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
