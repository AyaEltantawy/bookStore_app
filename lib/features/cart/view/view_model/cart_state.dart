import 'package:bookstore_app/features/cart/data/model/cart_model.dart';

abstract class CartState {}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final CartModel cart;
  CartLoadedState(this.cart);
}

class CartErrorState extends CartState {
  final String message;
  CartErrorState(this.message);
}
