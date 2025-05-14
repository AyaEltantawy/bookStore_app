import 'package:bookstore_app/features/checkout/view/widget/cart_item_widget.dart';

abstract class CheckoutState {}

class CheckoutInitialState extends CheckoutState {}

class CheckoutLoadingState extends CheckoutState {}

class CheckoutLoadedState extends CheckoutState {
  final CartItemWidget checkoutData;

  CheckoutLoadedState(checkoutData);
}

class CheckoutErrorState extends CheckoutState {
  final String message;

  CheckoutErrorState(this.message);
}

class CheckoutSuccessState extends CheckoutState {}
