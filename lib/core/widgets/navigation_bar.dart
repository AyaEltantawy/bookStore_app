import 'package:bookstore_app/features/category/view/presentation/category_screen.dart';
import 'package:bookstore_app/features/home/view/presentation/home_screen.dart';
import 'package:bookstore_app/features/profile/view/presentation/profile_screen.dart';
import 'package:bookstore_app/features/search/view/presentation/search_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/cart/view/presentation/cart_screen.dart';
import '../../features/cart/view/view_model/cart_cubit.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  List<Widget> screens = [
    HomeScreen(),
    CategoryScreen(),
    SearchScreen(),
    BlocProvider(
      create: (context) => CartCubit()..getCart(),
      child: const CartScreen(),
    ),
    ProfilePage()
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: currentIndex,
          backgroundColor: Colors.white,
          items: [
            Icon(Icons.home,
                size: 30, color: currentIndex == 0 ? Colors.pink : Colors.grey),
            Icon(Icons.book_outlined,
                size: 30, color: currentIndex == 1 ? Colors.pink : Colors.grey),
            Icon(Icons.search,
                size: 30, color: currentIndex == 2 ? Colors.pink : Colors.grey),
            Icon(Icons.shopping_cart,
                size: 30, color: currentIndex == 3 ? Colors.pink : Colors.grey),
            Icon(Icons.people,
                size: 30, color: currentIndex == 4 ? Colors.pink : Colors.grey),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        body: screens[currentIndex]);
  }
}
