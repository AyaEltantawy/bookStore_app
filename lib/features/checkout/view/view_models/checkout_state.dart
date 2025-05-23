//
// import 'package:bookstore_app/features/cart/data/model/cart_model.dart';
//
// abstract class CheckoutState {}
//
// class CheckoutInitialState extends CheckoutState {}
//
// class CheckoutLoadingState extends CheckoutState {}
//
// class CheckoutLoadedState extends CheckoutState {
//   final CheckoutModel cart;
//
//   CheckoutLoadedState(this.cart);
// }
//
// class CheckoutErrorState extends CheckoutState {
//   final String message;
//
//   CheckoutErrorState(this.message);
// }
//
// class CheckoutSuccessState extends CheckoutState {}
//

import 'package:bookstore_app/features/cart/data/model/cart_model.dart';

abstract class CheckoutState {}

class CheckoutInitialState extends CheckoutState {}
// Initial empty state, before anything happens.

class CheckoutLoadingState extends CheckoutState {}
// Emitted while loading data from the API.

class CheckoutLoadedState extends CheckoutState {
  final CartModel cart;
  CheckoutLoadedState(this.cart);
}
// Emitted when cart data is successfully fetched.
class CheckoutSuccessState extends CheckoutState {
  final String message;
  CheckoutSuccessState(this.message);
}
class CheckoutErrorState extends CheckoutState {
  final String message;
  CheckoutErrorState(this.message);
}
// Emitted when there's an error fetching or updating the cart.
