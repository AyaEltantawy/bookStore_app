import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/dio_helper.dart';
import '../../data/models/order.dart' as ui_order;
import 'package:bookstore_app/features/orders/view/view_model/order_history_model.dart';
import 'order_state.dart';

class OrderHistoryCubit extends Cubit<OrderState> {
  OrderHistoryCubit()
      : super(const OrderState(selectedFilter: 'Pending', orders: [], isLoading: false));

  // Define available filter options
  List<String> get filters => ['Pending', 'Processed', 'Shipped', 'Completed'];

  /// Sets the selected filter and fetches data accordingly
  void setFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter));
    final statusParam = filter.toLowerCase(); // assuming the API expects lowercase
    getOrderHistory(statusParam);
  }

  /// Fetches order history for the given status
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

      if ( data['status'] == 200 && data['data'] is List) {
        final List<dynamic> orderList = data['data'];

        final List<ui_order.Order> orders = orderList.map((orderJson) {
          return ui_order.Order(
            totalAmount: "${orderJson['total_amount'] ?? '0.00'}",
            status: orderJson['status'] ?? "Unknown",
            date: orderJson['created_at'] ?? "Unknown",
            paymentMethod: orderJson['payment_method'] ?? "N/A",
          );
        }).toList();

        emit(state.copyWith(orders: orders, isLoading: false));
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

}
