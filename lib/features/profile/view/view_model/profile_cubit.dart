import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../auth/views/presentation/create_account_screen.dart';
import '../../../auth/views/presentation/login_screen.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  // Fetch user profile and store image URL locally
  Future<void> getProfile() async {
    emit(ProfileLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No token found');

      final response = await DioHelper.getData(
        url: '/profile',
        token: token,
      );

      final userData = response.data['data'] as Map<String, dynamic>?;

      if (userData == null) {
        emit(ProfileErrorState(error: {'general': ['No user data found']}));
        return;
      }

      if (userData['image'] != null) {
        await prefs.setString('user_image', userData['image']);
      }

      emit(ProfileSuccessState(userData));
    } catch (e) {
      emit(ProfileErrorState(error: {
        'general': ['Failed to load profile: ${e.toString()}']
      }));
    }
  }

  // Update profile info including image (if File is passed)
  Future<void> updateProfile(BuildContext context, Map<String, dynamic> data) async {
    // Check if image is missing or invalid
    if (data['image'] == null || data['image'] is! File) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a profile image')),
      );
      return;
    }

    emit(ProfileLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No token found');

      final formData = FormData();

      for (final entry in data.entries) {
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
        await getProfile(); // Refresh updated data
        emit(UpdateProfileSuccess());
      } else {
        emit(ProfileErrorState(error: {
          'general': [response.data["message"] ?? 'Update failed.']
        }));
      }
    } catch (e) {
      emit(ProfileErrorState(error: {
        'general': ['Update failed: ${e.toString()}']
      }));
    }
  }


  // Controllers for help form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> sendHelpRequest(BuildContext context) async {
    final data = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'subject': subjectController.text.trim(),
      'content': contentController.text.trim(),
    };

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

      if (responseData['status'] == true) {
        emit(LoadingSuccess());
        Utils.showSnackBar(context, responseData["message"]);
      } else {
        emit(LoadingError());
        Utils.showSnackBar(context, responseData['message'] ?? "An error occurred.");
      }
    } catch (e) {
      emit(LoadingError());
      Utils.showSnackBar(context, "Something went wrong. Please try again.");
    }
  }

  // Log out user and navigate to login screen
  Future<void> logOut(BuildContext context) async {
    emit(LoadingLogOut());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No token found');

      final response = await DioHelper.postData(
        url: "/logout",
        token: token,
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == 200) {
        emit(LoadingSuccess());
        Utils.showSnackBar(context, responseData["message"]);

        // Clear SharedPreferences or any auth data if needed here
        await prefs.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        emit(LoadingError());
        Utils.showSnackBar(context, responseData['message'] ?? "An error occurred.");
      }
    } catch (e) {
      emit(LoadingError());
      Utils.showSnackBar(context, "Network or unexpected error. Please try again.");
    }
  }

  final TextEditingController passwordController = TextEditingController();

  // Delete user account with password confirmation
  Future<void> deleteAccount(BuildContext context) async {
    final data = {
      'password': passwordController.text.trim(),
    };

    emit(DeleteAccountLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        emit(DeleteAccountError());
        Utils.showSnackBar(context, 'No token found. Please log in again.');
        return;
      }

      final response = await DioHelper.postData(
        url: "/delete-profile",
        data: data,
        token: token,
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == true) {
        emit(DeleteAccountSuccess());
        Utils.showSnackBar(context, responseData["message"]);

        // Clear preferences
        await prefs.clear();


      } else {
        emit(DeleteAccountError());
        Utils.showSnackBar(context, responseData['message'] ?? "An error occurred.");
      }
    } catch (e) {
      emit(DeleteAccountError());
      Utils.showSnackBar(context, "Something went wrong. Please try again.");
    }
  }
}
