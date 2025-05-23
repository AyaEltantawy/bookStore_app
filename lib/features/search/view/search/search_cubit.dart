
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'search_state.dart';


class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
 Future<void> fetchSearch(String? query) async {
    emit(SearchLoading());

    try {
      final response = await DioHelper.getData(
        url: '/books-search',
        query: {'title':query}, // استخدم المتغير المرسل
      );

      final List<dynamic>? booksJson = response.data['data']['books'];
      final books = booksJson?.map((json) => Books.fromJson(json)).toList() ?? [];

      emit(SearchSuccess(books));
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'خطأ في الاتصال بالسيرفر';
      emit(SearchError(message));
    } catch (e) {
      emit(SearchError('حدث خطأ غير متوقع'));
    }
  }


   Future<void> fetchFilteredBooks({String? category, int? price}) async {
    emit(SearchLoading());

    try {
      final response = await DioHelper.getData(
        url: 'books-filter',
        query: {
          if (category != null) 'category': category,
          if (price != null) 'price': price.toString(),
        },
      );

      if (response.statusCode == 200) {
        final List booksJson = response.data['data']['books'];

        List<Books> filteredBooks = [];
        for (int i = 0; i < booksJson.length; i++) {
          Books x = Books.fromJson(booksJson[i]);
          filteredBooks.add(x);
        }
        emit(SearchSuccess(filteredBooks));
      } else {
        emit(SearchError(response.data["message"] ?? 'حدث خطأ غير متوقع'));
      }
    } catch (e) {
      emit(SearchError('فشل الاتصال بالخادم: $e'));
    }
  }
}
