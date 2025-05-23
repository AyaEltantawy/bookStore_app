import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/book_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookDetailsCubit() : super(BookDetailsInitial());

  static BookDetailsCubit get(context) => BlocProvider.of(context);

  Future<void> fetchBookDetails(int bookId) async {
    emit(BookDetailsLoading());

    try {
      final response = await DioHelper.getData(
        url: '/books/$bookId',
        query: {},
      );

      if (response.data != null && response.data is Map<String, dynamic>) {
        final bookDetailsModel = BookDetails.fromJson(response.data);
        final book = bookDetailsModel.data?.book;

        if (book != null) {
          emit(BookDetailsSuccess(book)); // Emit only the book here
        } else {
          emit(BookDetailsError('Book details not found'));
        }
      } else {
        emit(BookDetailsError('Invalid response format'));
      }
    } catch (e) {
      print('Error fetching book details: $e');
      emit(BookDetailsError('Failed to load book details'));
    }
  }
}
