import 'package:bookstore_app/features/home/data/models/book_model.dart';

abstract class BestSellerState {}

class BestSellerInitial extends BestSellerState {}

class BestSellerLoading extends BestSellerState {}

class BestSellerSuccess extends BestSellerState {
  final List<Books> books;

  BestSellerSuccess(this.books);
}

class BestSellerError extends BestSellerState {
  final String message;

  BestSellerError(this.message);
}
