// import 'package:bookstore_app/features/order/order_details.dart';
// import 'package:flutter/material.dart';

// class Order {
//   final String number;
//   final String status;
//   final String date;
//   final String address;

//   Order({
//     required this.number,
//     required this.status,
//     required this.date,
//     required this.address,
//   });
// }

// class OrderHistoryScreen extends StatefulWidget {
//   @override
//   _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
// }

// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   String selectedFilter = 'All';

//   List<Order> orders = [
//     Order(
//         number: "#123456",
//         status: "Canceled",
//         date: "Jul, 31 2024",
//         address: "Maadi, Cairo, Egypt."),
//     Order(
//         number: "#123456",
//         status: "Completed",
//         date: "Jul, 31 2024",
//         address: "Maadi, Cairo, Egypt."),
//     Order(
//         number: "#123456",
//         status: "In progress",
//         date: "Jul, 31 2024",
//         address: "Maadi, Cairo, Egypt."),
//   ];

//   List<String> filters = ['All', 'In progress', 'Completed', 'Canceled'];

//   List<Order> get filteredOrders {
//     if (selectedFilter == 'All') return orders;
//     return orders.where((order) => order.status == selectedFilter).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Order history", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: BackButton(color: Colors.black),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Wrap(
//               spacing: 8,
//               children: filters.map((filter) {
//                 final isSelected = filter == selectedFilter;
//                 return ChoiceChip(
//                   label: Text(filter),
//                   selected: isSelected,
//                   onSelected: (_) {
//                     setState(() => selectedFilter = filter);
//                   },
//                   selectedColor: Colors.pink[200],
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredOrders.length,
//               itemBuilder: (context, index) {
//                 final order = filteredOrders[index];
//                 return OrderCard(order: order);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OrderCard extends StatelessWidget {
//   final Order order;

//   const OrderCard({required this.order});

//   Widget buildStatusStepper(String status) {
//     if (status != "In progress") return SizedBox.shrink();
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Column(children: [
//           Icon(Icons.check_circle, color: Colors.pink),
//           Text("Order placed")
//         ]),
//         Expanded(child: Divider(color: Colors.pink, thickness: 2)),
//         Column(children: [
//           Icon(Icons.check_circle, color: Colors.pink),
//           Text("Shipping")
//         ]),
//         Expanded(child: Divider(color: Colors.grey, thickness: 2)),
//         Column(children: [
//           Icon(Icons.radio_button_unchecked, color: Colors.grey),
//           Text("Completed")
//         ]),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Align(
//                 alignment: Alignment.topRight,
//                 child: Icon(Icons.delete_outline, color: Colors.pink)),
//             Text("Order No. ${order.number}"),
//             Text("Status: ${order.status}"),
//             Text("Date: ${order.date}"),
//             Text("Address: ${order.address}"),
//             if (order.status == "In progress") SizedBox(height: 12),
//             buildStatusStepper(order.status),
//             if (order.status != "In progress")
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: TextButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => OrderDetailsScreen()),
//                     );
//                   },
//                   icon: Icon(Icons.arrow_forward, color: Colors.pink),
//                   label: Text("View order detail",
//                       style: TextStyle(color: Colors.pink)),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
