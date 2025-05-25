import 'package:bookstore_app/features/orders/view/view_model/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../orders/view/view_model/order_state.dart';


class AddReviewScreen extends StatefulWidget {
  final int orderId;
  final String bookTitle;

  const AddReviewScreen({
    super.key,
    required this.orderId,
    required this.bookTitle,
  });

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  int selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // <-- Form key

  Widget buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            starIndex <= selectedRating ? Icons.star : Icons.star_border,
            color: Colors.pink,
            size: 32,
          ),
          onPressed: () {
            setState(() => selectedRating = starIndex);
          },
        );
      }),
    );
  }

  void _onSubmit(OrderHistoryCubit controller) {
    // Validate form fields
    if (selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating.')),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      // If valid, submit review
      controller.addReview(context, widget.orderId, selectedRating, _reviewController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderHistoryCubit(),
      child: BlocBuilder<OrderHistoryCubit, OrderState>(
        builder: (context, state) {
          final controller = BlocProvider.of<OrderHistoryCubit>(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Add Review", style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: const BackButton(color: Colors.black),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,  // <-- Wrap in Form
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book info
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.book, size: 40),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.bookTitle,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text("Rate this item", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    buildStarRating(),
                    const SizedBox(height: 24),
                    const Text("Write a review", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _reviewController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Share your experience...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a review comment";
                        }
                        if (value.trim().length < 30) {
                          return "Comment must be at least 30 characters";
                        }
                        return null;
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _onSubmit(controller),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Submit Review", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

