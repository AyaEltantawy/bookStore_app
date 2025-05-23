import 'package:bookstore_app/features/home/data/models/book_model.dart';

abstract class AllBooksState {}

class AllBooksInitial extends AllBooksState {}

class AllBooksLoading extends AllBooksState {}

class AllBooksSuccess extends AllBooksState {
  final List<BookModel> books;

  AllBooksSuccess({required this.books});
}

class AllBooksError extends AllBooksState {
  final String message;

  AllBooksError(this.message);
}
