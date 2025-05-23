import 'package:bookstore_app/features/profile/view/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/onboarding/splash_screen.dart';
import 'cach_helper/cache_helper.dart';

String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init(); // تهيئة dio
  await CacheHelper.init();
  token = CacheHelper.getData(key: 'token');
  runApp(BookStoreApp());
}

// ignore: camel_case_types
class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // ممكن تغيرها لتجربة شاشة تانية
    );
  }
}
