import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/magic_router/magic_router.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../auth/views/presentation/create_account_screen.dart';
import '../../../auth/views/presentation/login_screen.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await DioHelper.getData(
        url: '/profile',
        token: token,
      );

      final userData = response.data['data'];

      if (userData['image'] != null) {
        await prefs.setString('user_image', userData['image']);
      }

      emit(ProfileSuccessState(userData));
    } catch (_) {
      emit(ProfileErrorState(error: {
        'general': ['Failed to load profile']
      }));
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    emit(ProfileLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final formData = FormData();

      for (var entry in data.entries) {
        if (entry.key == 'image' && entry.value is File) {
          formData.files.add(MapEntry(
            'image',
            await MultipartFile.fromFile(entry.value.path, filename: 'profile.jpg'),
          ));
        } else {
          formData.fields.add(MapEntry(entry.key, entry.value.toString()));
        }
      }

      final response = await DioHelper.postData(
        url: '/update-profile',
        token: token,
        data: formData,
        isFormData: true,
      );

      if (response.data["status"] == 200) {
        await getProfile(); // Also updates prefs
        emit(UpdateProfileSuccess());
      } else {
        emit(ProfileErrorState(error: {'general': [response.data["message"] ?? 'Update failed.']}));
      }
    } catch (_) {
      emit(ProfileErrorState(error: {'general': ['Update failed. Try again.']}));
    }
  }
  TextEditingController nameController=TextEditingController();
  TextEditingController  emailController = TextEditingController();
  TextEditingController  subjectController = TextEditingController();
  TextEditingController  contentController = TextEditingController();
  TextEditingController  passwordController = TextEditingController();

  Future<void> help(BuildContext context) async {
    final data = {
      'name': nameController.text.trim(),
      'email':emailController.text.trim(),
      'subject':subjectController.text.trim(),
      'content':contentController.text.trim()
    };

    print('Request Body: $data');
    emit(LoadingHelp());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(LoadingError());
        Utils.showSnackBar(context, 'No token found. Please log in again.');
        return;
      }

      final response = await DioHelper.postData(
        url: "/send-message",
        data: data,
        token: token,
      );

      final responseData = response.data as Map<String, dynamic>;
      print("Response Data: $responseData");

      if (responseData['status'] == true) {
        emit(LoadingSuccess());
        Utils.showSnackBar(context, responseData["message"]);

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
  Future<void> logOut(BuildContext context) async {
    emit(LoadingLogOut());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(LoadingError());
        Utils.showSnackBar(context, 'No token found. Please log in again.');
        return;
      }

      final response = await DioHelper.postData(
        url: "/logout",
        token: token,

      );

      final responseData = response.data as Map<String, dynamic>;
      print("✅ Logout Response Data: $responseData");

      if (responseData['status'] == 200) {

        emit(LoadingSuccess());
        Utils.showSnackBar(context, responseData["message"]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        emit(LoadingError());
        Utils.showSnackBar(
          context,
          responseData['message'] ?? "An error occurred.",
        );
      }
    } on DioException catch (dioError) {
      emit(LoadingError());
      print("❌ Dio Error: ${dioError.response?.data ?? dioError.message}");
      Utils.showSnackBar(
        context,
        "Network error. Please try again.",
      );
    } catch (e) {
      emit(LoadingError());
      print("❌ Unexpected Error: $e");
      Utils.showSnackBar(
        context,
        "Something went wrong. Please try again.",
      );
    }
  }
  Future<void> deleteAccount(BuildContext context) async {
    final data = {
      'password':passwordController.text.trim()
    };

    print('Request Body: $data');
    emit(DeleteAccountLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(LoadingError());
        Utils.showSnackBar(context, 'No token found. Please log in again.');
        return;
      }

      final response = await DioHelper.postData(
        url: "/delete-profile",
        data: data,
        token: token,
      );

      final responseData = response.data as Map<String, dynamic>;
      print("Response Data: $responseData");

      if (responseData['status'] == true) {
        emit(DeleteAccountSuccess());
        Utils.showSnackBar(context, responseData["message"]);
        Navigator.push(context, MaterialPageRoute(builder: (_) => CreateAccountPage()));
      } else {
        emit(DeleteAccountError());
        Utils.showSnackBar(
          context,
          responseData['message'] ?? "An error occurred.",
        );
      }
    } catch (e) {
      emit( DeleteAccountError());
      Utils.showSnackBar(
        context,
        "Something went wrong. Please try again.",
      );
      print("❌ Error: $e");
    }
  }
  
}
