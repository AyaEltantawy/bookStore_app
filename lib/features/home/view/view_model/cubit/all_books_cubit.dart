import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'all_books_state.dart';

class AllBooksCubit extends Cubit<AllBooksState> {
  AllBooksCubit() : super(AllBooksInitial());

  List<BookModel>? books;

  Future<void> fetchBooks() async {
    emit(AllBooksLoading());

    try {
      final response = await DioHelper.getData(url: "/books", query: {'limit': 10});
      final List<BookModel> fetchedBooks = (response.data['data']['books'] as List)
          .map((book) => BookModel.fromJson(book))
          .toList();

      books = fetchedBooks;
      emit(AllBooksSuccess(books: fetchedBooks));
    } catch (e) {
      emit(AllBooksError(e.toString()));
    }
  }
}
