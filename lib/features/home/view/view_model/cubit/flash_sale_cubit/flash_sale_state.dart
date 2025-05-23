import 'package:bookstore_app/features/home/data/models/book_model.dart';

abstract class FlashSaleState {}

class FlashSaleInitial extends FlashSaleState {}

class FlashSaleLoading extends FlashSaleState {}

class FlashSaleSuccess extends FlashSaleState {
  final List<Books> books;

  FlashSaleSuccess({required this.books});
}

class FlashSaleError extends FlashSaleState {
  final String message;

  FlashSaleError(this.message);
}
