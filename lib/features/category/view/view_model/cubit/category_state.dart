
import 'package:bookstore_app/features/category/data/model/category_model.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<Categories> categories;

  CategorySuccess(this.categories);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}
