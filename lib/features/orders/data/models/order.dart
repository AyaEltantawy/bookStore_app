import '../../view/view_model/order_history_model.dart';

class Order {
  final String totalAmount;
  final String status;
  final String date;
  final String paymentMethod;

  Order({
    required this.totalAmount,
    required this.status,
    required this.date,
    required this.paymentMethod,
  });
}

