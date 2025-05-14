import 'dart:async';

import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/view_model/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitState());

  HomeCubit get(context) => BlocProvider.of(context);

  List<Books>? books;

  getlimitBooks() {
    emit(GetLimitBooksLoadingState());
    DioHelper.getData(url: "/books", query: {'limit': 2}).then((value) {
      books = List<Books>.from(
        value.data['data']['books'].map((book) => Books.fromJson(book)),
      );
      emit(GetLimitBooksSucessState(books: books!));
    }).onError(
      (error, stackTrace) {
        emit(GetLimitBooksErrorState());
      },
    );
  }
}
