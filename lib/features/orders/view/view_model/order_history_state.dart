import 'package:dartz/dartz.dart';

abstract class OrderHistoryState{}
class OrderHistoryLoadingState extends OrderHistoryState{}
class ProductsSuccessState extends OrderHistoryState{}
class ProductsErrorState extends OrderHistoryState{}