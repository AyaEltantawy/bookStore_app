import 'package:bookstore_app/features/cart/data/model/cart_model.dart';

abstract class CartState {}

class CartInitialState extends CartState {}
// Initial empty state, before anything happens.

class CartLoadingState extends CartState {}
// Emitted while loading data from the API.

class CartLoadedState extends CartState {
  final CartModel cart;

  CartLoadedState(this.cart);
}
// Emitted when cart data is successfully fetched.

class CartErrorState extends CartState {
  final String message;

  CartErrorState(this.message);
}

// Emitted when there's an error fetching or updating the cart.
class DeleteProductLoadingState extends CartState {}

class DeleteProductSuccessState extends CartState {}

class DeleteProductErrorState extends CartState {}
