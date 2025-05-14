import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitialState());

  static CheckoutCubit get(context) => BlocProvider.of(context);

  Future<void> getCheckout() async {
    emit(CheckoutLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await DioHelper.getData(
        url: '/checkout',
        token: token ?? '',
        query: {},
      );

      if (response.statusCode == 200) {
        final checkoutData = response.data['data']['data'];

        print('checccccccccccccccccccout');
        print(checkoutData);
        emit(CheckoutLoadedState(checkoutData!));
      } else {
        emit(CheckoutErrorState('Failed to load checkout data'));
      }
    } catch (e) {
      emit(CheckoutErrorState('Error: $e'));
    }
  }

  Future<void> placeOrder() async {
    emit(CheckoutLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await DioHelper.postData(
        url: '/place-order',
        data: {},
        token: token ?? '',
      );

      if (response.statusCode == 200) {
        emit(CheckoutSuccessState('Order placed successfully'));
      } else {
        emit(CheckoutErrorState('Failed to place order'));
      }
    } catch (e) {
      emit(CheckoutErrorState('Error: $e'));
    }
  }
}
