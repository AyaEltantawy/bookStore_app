import 'package:bookstore_app/core/magic_router/magic_router.dart';
import 'package:bookstore_app/core/utils/snack_bar.dart';
import 'package:bookstore_app/features/cart/data/model/cart_model.dart';
import 'package:bookstore_app/features/orders/view/presentation/order_history_screen.dart';
import 'package:dio/dio.dart';
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
        Utils.showSnackBar(
            context, data['message'] ?? 'Order placed successfully');
        emit(CheckoutSuccessState(
            data['message'] ?? 'Order placed successfully'));
        await getCheckout(); // refresh cart if needed
      } else {
        // Handle error response returned with status = false
        final errorMessage = data?['message'] ?? 'Order failed';
        Utils.showSnackBar(context, errorMessage);
        emit(CheckoutErrorState(errorMessage));
      }
    } on DioError catch (dioError) {
      // Dio error — extract message from server response
      String errorMessage = 'Order failed';
      if (dioError.response != null && dioError.response?.data != null) {
        final responseData = dioError.response!.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      } else {
        errorMessage = dioError.message!;
      }

      Utils.showSnackBar(context, errorMessage);
      emit(CheckoutErrorState(errorMessage));
    } catch (e) {
      // Other unexpected errors
      final errorMessage = 'Unexpected error: $e';
      Utils.showSnackBar(context, errorMessage);
      emit(CheckoutErrorState(errorMessage));
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
