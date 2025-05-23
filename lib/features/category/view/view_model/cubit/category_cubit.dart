
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/category/data/model/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  Future<void> fetchCategories() async {
    try {
      emit(CategoryLoading());

      final response = await DioHelper.getData(url: 'categories', query: {}); // ← عدل الرابط حسب API

      final categoryModel = CategoryModel.fromJson(response.data);

      if (categoryModel.status == 200) {
        emit(CategorySuccess(categoryModel.data?.categories ?? []));
      } else {
        emit(CategoryError(categoryModel.message ?? 'Failed to load categories'));
      }
    } catch (e) {
      emit(CategoryError('An error occurred: $e'));
    }
  }
}
