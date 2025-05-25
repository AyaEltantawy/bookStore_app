import 'package:bookstore_app/core/magic_router/magic_router.dart';
import 'package:bookstore_app/core/utils/snack_bar.dart';
import 'package:bookstore_app/features/cart/data/model/cart_model.dart';
import 'package:bookstore_app/features/orders/view/presentation/order_history_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/dio_helper.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitialState());

  CartModel? checkout;

  Future<void> getCheckout() async {
    emit(CheckoutLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      print("object: $token");
      final response = await DioHelper.getData(
        url: '/checkout',
        token: token,
        query: {},
      );

      print("Checkout response: ${response.data['data']['data']}");

      checkout = CartModel.fromJson(response.data['data']['data']);
      print("Checkout: ${response.data['data']['data']}");

      emit(CheckoutLoadedState(checkout!));
    } catch (error) {
      print("Checkout error: $error");
      emit(CheckoutErrorState(error.toString()));
    }
  }

  void placeOrder(BuildContext context) async {
    try {
      emit(CheckoutLoadingState());

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await DioHelper.postData(
        url: '/place-order',
        data: {},
        token: token,
      );

      final data = response?.data;
      if (data != null && data['status'] == true) {

        Utils.showSnackBar(context, data['message']);

        emit(CheckoutSuccessState(data['message']));


      } else {
        emit(CheckoutErrorState(data?['message'] ?? 'Order failed'));
      }

      await getCheckout(); // Optionally refresh the cart
    } catch (e) {
      emit(CheckoutErrorState('Exception: $e'));
    }
  }



  Future<void> updateQuantity(int bookId, int qty) async {
    try {
      emit(CheckoutLoadingState());

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      await DioHelper.postData(
        url: '/update-cart',
        data: {'book_id': bookId, 'quantity': qty},
        token: token,
      );

      await getCheckout(); // Refresh cart
    } catch (e) {
      emit(CheckoutErrorState('Exception: $e'));
    }
  }
}
