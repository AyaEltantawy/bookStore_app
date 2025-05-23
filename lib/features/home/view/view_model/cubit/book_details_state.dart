import 'package:bookstore_app/features/home/data/models/book_model.dart';

abstract class BookDetailsState {}

class BookDetailsInitial extends BookDetailsState {}

class BookDetailsLoading extends BookDetailsState {}

class BookDetailsSuccess extends BookDetailsState {
  final Books book;  // فقط الكتاب هنا
  BookDetailsSuccess(this.book);
}

class BookDetailsError extends BookDetailsState {
  final String message;
  BookDetailsError(this.message);
}
