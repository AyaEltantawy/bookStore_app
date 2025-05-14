import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/cart_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitialState());

  static CartCubit get(context) => BlocProvider.of(context);

  CartModel? cart;

  Future<void> getCart() async {
    emit(CartLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response =
          await DioHelper.getData(url: '/show-cart', token: token, query: {});

      cart = CartModel.fromJson(response.data['data']['data']);
      emit(CartLoadedState(cart!));
    } catch (error) {
      emit(CartErrorState(error.toString()));
    }
  }

  Future<void> updateQuantity(int bookId, int qty) async {
    try {
      emit(CartLoadingState());

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await DioHelper.postData(
          url: '/update-cart',
          data: {'book_id': bookId, 'quantity': qty},
          token: token);

      await getCart();
    } catch (e) {
      emit(CartErrorState('Exception: $e'));
    }
  }
}
