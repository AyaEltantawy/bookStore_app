import 'package:bookstore_app/core/magic_router/magic_router.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/features/auth/views/view_model/auth_state.dart';
import 'package:bookstore_app/features/home/view/presentation/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../cach_helper/cache_helper.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitState());

  static AuthCubit get(context) => BlocProvider.of(context);

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());

    try {
      final response = await DioHelper.postData(
        url: '/sign-in',
        data: {
          'email': email,
          'password': password,
        },
      );

      final message = response.data['message'] ?? 'Login successful';
      final data = response.data['data'] as Map<String, dynamic>?;
      if (data == null) throw Exception("No user data returned");

      final token = data['token'];
      final user = data['user'] as Map<String, dynamic>?;

      if (token != '') {
        await CacheHelper.saveData(key: 'token', value: token);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', user!['id']);
        await prefs.setString('user_name', user['name']);
        await prefs.setString('user_email', user['email']);
        await prefs.setString('user_image', user['image']);

        emit(LoginSuccessState(message: message));
        MagicRouter.navigateTo(const HomeScreen());
      } else {
        emit(LoginErrorState(error: "Invalid token or user data received"));
      }
    } catch (error) {
      print("SignIn Error: $error");
      emit(LoginErrorState(error: "Login failed. Please try again."));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String password_confirmation,
  }) async {
    emit(SignUpLoadingState());

    try {
      final response = await DioHelper.postData(
        url: '/sign-up',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password_confirmation,
        },
      );

      final message = response.data['message'] ?? 'Registration successful';
      final data = response.data['data'] as Map<String, dynamic>?;

      if (data == null) throw Exception("No user data returned");

      final token = data['token'] as String?;
      final user = data['user'] as Map<String, dynamic>?;

      if (token != null && token.isNotEmpty && user != null) {
        // Save token and user info to cache/shared preferences
        await CacheHelper.saveData(key: 'token', value: token);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setInt('user_id', user['id']);
        await prefs.setString('user_name', user['name']);
        await prefs.setString('user_email', user['email']);
        await prefs.setString('user_image', user['image'] ?? '');

        emit(SignUpSuccessState(message: message));
        MagicRouter.navigateTo(const HomeScreen());
      } else {
        emit(SignUpErrorState(error: {
          'general': ['Invalid token or user data received']
        }));
      }
    } catch (error) {
      print("SignUp Error: $error");
      emit(SignUpErrorState(error: {
        'general': ['Failed to register, please try again.']
      }));
    }
  }}
