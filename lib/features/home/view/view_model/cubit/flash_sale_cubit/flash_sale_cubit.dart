


import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/home/view/view_model/cubit/flash_sale_cubit/flash_sale_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashSaleCubit extends Cubit<FlashSaleState> {
  FlashSaleCubit() : super(FlashSaleInitial());
   
      FlashSaleCubit get(context) => BlocProvider.of(context);

List<Books>? books;

  getlimitBooks()async{
    
    emit(FlashSaleLoading());
    await DioHelper.getData(url: "/books-sale", query: {
      'limit' : 2
    }).then((value){
      books = List<Books>.from(
  value.data['data']['books'].map((book) => Books.fromJson(book)),
);
      emit(FlashSaleSuccess(books: books!));
    }).onError((error, stackTrace) {
      emit(FlashSaleError(error.toString()));
    },);
  }


}