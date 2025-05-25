import '../../data/models/order.dart' as ui_order;

class OrderState {
  final String selectedFilter;
  final List<ui_order.Order> orders;
  final bool isLoading;
  final String? error;

  const OrderState({
    this.selectedFilter = "Pending",
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({
    String? selectedFilter,
    List<ui_order.Order>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
class LoadingAddReview extends OrderState{}
class LoadingAddReviewError extends OrderState{}
class LoadingAddReviewSuccess extends OrderState{}