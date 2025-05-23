import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:bookstore_app/core/utils/snack_bar.dart';
import 'package:bookstore_app/features/auth/views/presentation/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/magic_router/magic_router.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordStateInit());

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> confirmPassword(BuildContext context) async {
    final data = {
      'old_password': currentPasswordController.text.trim(),
      'new_password': newPasswordController.text.trim(),
      'new_password_confirmation': confirmPasswordController.text.trim(),
    };

    print('Request Body: $data');
    emit(LoadingConfirm());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(LoadingError());
        Utils.showSnackBar(context, 'No token found. Please log in again.');
        return;
      }

      final response = await DioHelper.postData(
        url: "/update-password",
        data: data,
        token: token,
      );

      final responseData = response.data as Map<String, dynamic>;
      print("Response Data: $responseData");

      if (responseData['status'] == true) {
        emit(LoadingSuccess());
        Utils.showSnackBar(context, responseData["message"]);
        MagicRouter.navigateTo(LoginScreen());
      } else {
        emit(LoadingError());
        Utils.showSnackBar(
          context,
          responseData['message'] ?? "An error occurred.",
        );
      }
    } catch (e) {
      emit(LoadingError());
      Utils.showSnackBar(
        context,
        "Something went wrong. Please try again.",
      );
      print("❌ Error: $e");
    }
  }
}
