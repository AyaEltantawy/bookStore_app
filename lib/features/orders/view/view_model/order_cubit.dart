import 'package:bookstore_app/core/magic_router/magic_router.dart';
import 'package:bookstore_app/core/utils/snack_bar.dart';
import 'package:bookstore_app/features/order/model/show_single_order_model.dart';
import 'package:bookstore_app/features/orders/view/view_model/order_history_state.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/dio_helper.dart';
import '../../data/models/order.dart' as ui_order;
import 'order_state.dart';

class OrderHistoryCubit extends Cubit<OrderState> {
  OrderHistoryCubit()
      : super(const OrderState(selectedFilter: 'Pending', orders: [], isLoading: false));

  // Available filter options
  List<String> get filters => ['Pending', 'Processed', 'Shipped', 'Completed'];

  /// Set filter and fetch orders
  void setFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter, error: null));
    getOrderHistory(filter.toLowerCase());
  }

  /// Fetch order history from API
  Future<void> getOrderHistory(String status) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await DioHelper.getData(
        url: "/order-history?status=$status",
        token: token,
      );

      final data = response?.data;

      if (data != null && data['status'] == 200 && data['data'] is List) {
        final List<dynamic> orderList = data['data'];
        final List<ui_order.Order> orders = orderList.map((orderJson) {
          return ui_order.Order(
            reviewId:orderJson['review_id'],
            orderId: orderJson['id'],
            totalAmount: "${orderJson['total_amount'] ?? '0.00'}",
            status: orderJson['status'] ?? "Unknown",
            date: orderJson['created_at'] ?? "Unknown",
            paymentMethod: orderJson['payment_method'] ?? "N/A",
          );
        }).toList();

        emit(state.copyWith(orders: orders, isLoading: false, error: null));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: data?['message'] ?? "Failed to fetch order history",
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  ShowSingleOrderModel? showSingleOrderModel;

  /// Fetch single order details
  Future<void> showSingleOrder(int? orderId) async {
    if (orderId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await DioHelper.getData(
        url: "/show-single-order?order_id=$orderId",
        token: token,
      );

      if (response != null && response.data != null) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          if (data['status'] == 200 && data['data'] != null) {
            showSingleOrderModel = ShowSingleOrderModel.fromJson(data);
            emit(state.copyWith()); // trigger rebuild if needed
          } else {
            Utils.showSnackBar(MagicRouter.currentContext!, data["error"] ?? "Unknown error");
          }
        }
      }
    } catch (e) {
      Utils.showSnackBar(MagicRouter.currentContext!, "Error loading order details: $e");
    }
  }
  TextEditingController commentController =TextEditingController();
  Future<void> addReview(
      BuildContext context,
      int? orderId,
      int? rateNumber,
      TextEditingController commentController,
      ) async {
    final data = {
      'order_id': orderId,
      'rating': rateNumber,
      'comment': commentController.text.trim(),
    };

    print('Add Review BODY: $data');
    emit(LoadingAddReview());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(LoadingAddReviewError());
        Utils.showSnackBar(context, 'No token found. Please log in again.');
        return;
      }

      final response = await DioHelper.postData(
        url: "/order-review",
        data: data,
        token: token,
      );

      final responseData = response.data as Map<String, dynamic>;
      print("Response Data: $responseData");

      if (responseData['status'] == true) {
        emit(LoadingAddReviewSuccess());
        Utils.showSnackBar(context, responseData["message"]);
      } else {
        emit(LoadingAddReviewError());
        Utils.showSnackBar(
          context,
          responseData['message'] ?? "An error occurred.",
        );
      }
    } on DioException catch (e) {
      // Handle validation errors from backend (HTTP 400 with error details)
      if (e.response != null && e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        String errorMessage = "Something went wrong";

        if (errorData != null && errorData is Map<String, dynamic>) {
          if (errorData['data'] != null && errorData['data']['comment'] != null) {
            // 'comment' errors is usually a list
            final List errors = errorData['data']['comment'];
            errorMessage = errors.join(", ");
          } else if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        }

        emit(LoadingAddReviewError());
        Utils.showSnackBar(context, errorMessage);
      } else {
        // Other DioExceptions
        emit(LoadingAddReviewError());
        Utils.showSnackBar(context, "Failed to submit review. Please try again.");
      }
    } catch (e) {
      emit(LoadingAddReviewError());
      Utils.showSnackBar(context, "Something went wrong. Please try again.");
      print("❌ Error: $e");
    }
  }
}
