import 'package:bookstore_app/features/orders/view/view_model/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/order.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit()
      : super(OrderHistoryState(
          selectedFilter: 'All',
          orders: [
            Order(
              number: "#123456",
              status: "Canceled",
              date: "Jul, 31 2024",
              address: "Maadi, Cairo, Egypt.",
            ),
            Order(
              number: "#123457",
              status: "Completed",
              date: "Jul, 30 2024",
              address: "Nasr City, Cairo, Egypt.",
            ),
            Order(
              number: "#123458",
              status: "In progress",
              date: "Jul, 29 2024",
              address: "Zamalek, Cairo, Egypt.",
            ),
          ],
        ));

  List<String> get filters => ['All', 'In progress', 'Completed', 'Canceled'];

  void setFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter));
  }
}
