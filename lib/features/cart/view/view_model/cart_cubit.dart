import 'package:bookstore_app/features/home/view/view_model/home_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/magic_router/magic_router.dart';
import '../../../../core/services/dio_helper.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../data/model/cart_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitialState());

  CartModel? cart;

  Future<void> getCart() async {
    emit(CartLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      print("object: $token");
      final response = await DioHelper.getData(
        url: '/show-cart',
        token: token,
        query: {},
      );

      print("Cart response: ${response.data['data']['data']}");

      cart = CartModel.fromJson(response.data['data']['data']);
      print("Cart: ${response.data['data']['data']}");

      emit(CartLoadedState(cart!));
    } catch (error) {
      print("Cart error: $error");
      emit(CartErrorState(error.toString()));
    }
  }

  Future<void> updateQuantity(int bookId, int qty) async {
    try {
      emit(CartLoadingState());

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      await DioHelper.postData(
        url: '/update-cart',
        data: {'book_id': bookId, 'quantity': qty},
        token: token,
      );

      await getCart(); // Refresh cart
    } catch (e) {
      emit(CartErrorState('Exception: $e'));
    }
  }

  Future<void> deleteCartProduct(BuildContext context,int bookId) async {
    emit(DeleteProductLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(DeleteProductErrorState());
        Utils.showSnackBar(context, "Authentication token not found.");
        return;
      }

      final response = await DioHelper.postData(
        url: '/remove-from-cart',
        data: {'book_id': bookId},
        token: token,
      );

      final data = response.data as Map<String, dynamic>;

      if (data['status'] == 200) {
        Utils.showSnackBar(context, data['message']);
        emit(DeleteProductSuccessState());


        // Refresh cart after deletion
       await getCart();
      } else {
        emit(DeleteProductErrorState());
        Utils.showSnackBar(context, data['message'] ?? 'Failed to delete item.');
      }
    } catch (e) {
      emit(DeleteProductErrorState());
      Utils.showSnackBar(context, 'An error occurred: ${e.toString()}');
    }
  }

}