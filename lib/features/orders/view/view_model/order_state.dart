import 'package:equatable/equatable.dart';

import '../../data/models/order.dart';

class OrderHistoryState extends Equatable {
  final String selectedFilter;
  final List<Order> orders;

  const OrderHistoryState({
    required this.selectedFilter,
    required this.orders,
  });

  List<Order> get filteredOrders {
    if (selectedFilter == 'All') return orders;
    return orders.where((order) => order.status == selectedFilter).toList();
  }

  OrderHistoryState copyWith({
    String? selectedFilter,
    List<Order>? orders,
  }) {
    return OrderHistoryState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [selectedFilter, orders];
}
