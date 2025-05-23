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

   deleteCartProduct() async {
     final body = {
       'book_id': 100,
    };
     emit(DeleteProductLoadingState());
     final response = await DioHelper.postData(url:'remove-from-cart',data: body,)
      .then((response) {
     final data = response.data as Map<String, dynamic>;

      if (data['status'] == true) {
        emit(DeleteProductSuccessState());
        Utils.showSnackBar(MagicRouter.currentContext!, data['message']);
         // fetchCartProducts();
  //      print(productId);
      } else {
       emit(DeleteProductErrorState());
       }
     });
  }

}
