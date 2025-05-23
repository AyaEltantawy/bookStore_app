import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
