import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/features/orders/view/view_model/order_cubit.dart';
import 'package:bookstore_app/features/orders/view/view_model/order_state.dart';
import 'package:bookstore_app/features/order/model/show_single_order_model.dart';

import '../../core/widgets/custome_elevated_button.dart';
import 'add_reviews.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int? orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderHistoryCubit()..showSingleOrder(orderId),
      child: BlocBuilder<OrderHistoryCubit, OrderState>(
        builder: (context, state) {
          final cubit = context.read<OrderHistoryCubit>();
          final orderData = cubit.showSingleOrderModel?.data;

          Data? orderDetails;
          try {
            orderDetails = orderData!.firstWhere((order) => order.id == orderId);
          } catch (e) {
            orderDetails = null;
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text("Order Details", style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: const BackButton(color: Colors.black),
            ),
            body: orderDetails == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total: \$${orderDetails.totalAmount ?? '0.00'}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(
                            "Status: ${orderDetails.status}",
                            style: TextStyle(
                              color: orderDetails.status?.toLowerCase() == "completed"
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("Date: ${orderDetails.createdAt}"),
                          const SizedBox(height: 4),
                          Text("Payment Method: ${orderDetails.paymentMethod}"),
                          const SizedBox(height: 4),
                          Text(orderDetails.reviewId != null ? "Already Reviewed" : "Not Reviewed")
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (orderDetails.books == null || orderDetails.books!.isEmpty)
                    const Text("No items found.")
                  else
                    ...orderDetails.books!.map((book) {
                      final qty = book.pivot?.quantity ?? 1;
                      final price = book.price is num
                          ? book.price as num
                          : num.tryParse(book.price.toString()) ?? 0;
                      return ListTile(
                        title: Text(book.title ?? "Untitled Book"),
                        subtitle: Text("Qty: $qty"),
                        trailing: Text("\$${price.toStringAsFixed(2)}"),
                      );
                    }).toList(),
                  const Divider(height: 32),
                  if (orderDetails.books != null && orderDetails.books!.isNotEmpty)
                    Builder(builder: (context) {
                      num grandTotal = 0;
                      for (var book in orderDetails!.books!) {
                        final qty = book.pivot?.quantity ?? 1;
                        final price = book.price is num
                            ? book.price as num
                            : num.tryParse(book.price.toString()) ?? 0;
                        grandTotal += price * qty;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildPriceRow("Subtotal", "\$${grandTotal.toStringAsFixed(2)}"),
                          buildPriceRow("Shipping", "\$10.00"),
                          const Divider(),
                          buildPriceRow("Total", "\$${(grandTotal + 10).toStringAsFixed(2)}", isBold: true),
                        ],
                      );
                    }),
                  const SizedBox(height: 20),
                  if (orderDetails.books != null && orderDetails.books!.isNotEmpty)
                    CustomElevatedButton(
                      text: "Add Review",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddReviewScreen(
                              orderId: orderId!,
                              bookTitle: orderDetails!.books!.first.title ?? "Book",
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPriceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(value, style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
