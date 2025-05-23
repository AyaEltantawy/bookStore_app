import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/best_seller_cubit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class BestSellerCubit extends Cubit<BestSellerState> {
  BestSellerCubit() : super(BestSellerInitial());

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api/v1/'
    ),
  );

  Future<void> fetchBestSellerBooks() async {
    emit(BestSellerLoading());

    try {
      final response = await  DioHelper.getData(url: '/book-slider',query: {});
  
   
     final List<dynamic> booksJson = response.data['data']['slider'];
 
   
      final books = booksJson.map((json) => Books.fromJson(json)).toList();
      
      emit(BestSellerSuccess(books));
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'خطأ في الاتصال بالسيرفر';
      emit(BestSellerError(message));
    } catch (e) {
      emit(BestSellerError('حدث خطأ غير متوقع'));
    }
  }


}
