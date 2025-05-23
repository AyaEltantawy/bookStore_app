import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/wish_list_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListInitial());

  Future<void> fetchWishlist() async {
    emit(WishListLoading());

    try {
      final response = await DioHelper.getData(url: '/show-wishlist', query: {});
      final List<dynamic>? wishlistJson = response.data['data']['books'];
      final books = wishlistJson?.map((json) => Books.fromJson(json)).toList()??[];

      emit(WishListSuccess(books));
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'خطأ في الاتصال بالسيرفر';
      emit(WishListError(message));
    } catch (e) {
      emit(WishListError('حدث خطأ غير متوقع'));
    }
  }
}
