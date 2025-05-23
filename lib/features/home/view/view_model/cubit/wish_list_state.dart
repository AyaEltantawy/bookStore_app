import 'package:bookstore_app/features/home/data/models/book_model.dart';

abstract class WishListState {}

class WishListInitial extends WishListState {}

class WishListLoading extends WishListState {}

class WishListSuccess extends WishListState {
  final List<Books> books;

  WishListSuccess(this.books);
}

class WishListError extends WishListState {
  final String message;

  WishListError(this.message);
}
