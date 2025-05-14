// import 'package:flutter/material.dart';

// class CheckoutPage extends StatelessWidget {
//   const CheckoutPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(),
//         title: const Text('Check out'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Book Item
//             Card(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.network(
//                     'https://m.media-amazon.com/images/I/81BE7eeKzAL._SL1500_.jpg',
//                     height: 100,
//                     width: 70,
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Rich Dad And Poor Dad',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const Text('Author: Robert T. Kiyosanki'),
//                         const Text('ASIN: B09TWSRMCB'),
//                         const SizedBox(height: 8),
//                         const Text(
//                           '\$40.00',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 TextButton.icon(
//                                   icon: const Icon(Icons.delete_outline),
//                                   label: const Text("Remove"),
//                                   onPressed: () {},
//                                 ),
//                                 TextButton.icon(
//                                   icon: const Icon(Icons.favorite_border),
//                                   label: const Text("Move to wishlist"),
//                                   onPressed: () {},
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(Icons.remove),
//                                   onPressed: () {},
//                                 ),
//                                 const Text("1"),
//                                 IconButton(
//                                   icon: const Icon(Icons.add),
//                                   onPressed: () {},
//                                 ),
//                               ],
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Price Summary
//             Column(
//               children: [
//                 summaryRow("Subtotal", "\$120"),
//                 summaryRow("Shipping", "Free Delivery"),
//                 summaryRow("Tax", "\$4"),
//                 const Divider(),
//                 summaryRow("Total", "\$124", isBold: true, color: Colors.pink),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Payment Method
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Payment Method",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 PaymentOption(title: "Online payment"),
//                 PaymentOption(title: "Cash on delivery", selected: true),
//                 PaymentOption(title: "POS on delivery"),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Add Note
//             TextField(
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: "Add note",
//                 border:
//                     OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Confirm Order Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pink,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 onPressed: () {},
//                 child: const Text("Confirm order"),
//               ),
//             )
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 2,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.book), label: "Books"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart), label: "My Cart"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   Widget summaryRow(String label, String value,
//       {bool isBold = false, Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//               color: color ?? Colors.black,
//               fontSize: isBold ? 16 : 14,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class PaymentOption extends StatelessWidget {
//   final String title;
//   final bool selected;
//   const PaymentOption({super.key, required this.title, this.selected = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       decoration: BoxDecoration(
//         border: Border.all(color: selected ? Colors.pink : Colors.grey),
//         borderRadius: BorderRadius.circular(8),
//         color: selected ? Colors.pink.shade50 : null,
//       ),
//       child: ListTile(
//         leading: Radio(
//           value: title,
//           groupValue: selected ? title : null,
//           onChanged: (_) {},
//         ),
//         title: Text(title),
//       ),
//     );
//   }
// }
