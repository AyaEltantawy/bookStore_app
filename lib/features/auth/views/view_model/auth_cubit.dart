import 'package:bookstore_app/core/services/dio_helper.dart';

import 'package:bookstore_app/features/auth/views/view_model/auth_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitState());

  AuthCubit get(context) => BlocProvider.of(context);

  signIn({required String email, required String password}) {
    emit(LoginLoadingState());
    DioHelper.postData(url: '/sign-in', data: {
      'email': email,
      'password': password,
    }).then((value) async {
      String message = value.data['message'];
      String token = value.data['data']['token'];
      Map<String, dynamic> user = value.data['data']['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('user_id', user['id']);
      await prefs.setString('user_name', user['name']);
      await prefs.setString('user_email', user['email']);
      await prefs.setString('user_image', user['image']);

      emit(LoginSuccessState(message: message));
    }).onError((error, stackTrace) {
      emit(LoginErrorState(error: "Invalid email or password"));
    });
  }

  signUp({
    required String name,
    required String email,
    required String password,
    required String password_confirmation,
  }) {
    emit(SignUpLoadingState());

    DioHelper.postData(url: '/sign-up', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation,
    }).then((value) async {
      String message = value.data['message'];
      String token = value.data['data']['token'];
      Map<String, dynamic> user = value.data['data']['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('user_id', user['id']);
      await prefs.setString('user_name', user['name']);
      await prefs.setString('user_email', user['email']);
      await prefs.setString('user_image', user['image']);

      emit(SignUpSuccessState(message: message));
    }).onError((error, stackTrace) {
      emit(SignUpErrorState(error: {
        'general': ['Failed to register, please try again']
      }));
    });
  }
}
