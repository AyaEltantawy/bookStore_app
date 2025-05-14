import 'package:bloc/bloc.dart';
import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  Map<String, dynamic>? user;

  Future<void> getProfile() async {
    emit(ProfileLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(ProfileErrorState(error: {
          'general': ['No token found. Please log in again.']
        }));

        return;
      }

      final response = await DioHelper.getData(
        url: '/profile',
        token: token,
        query: {},
      );

      final userData = response.data['data'];
      emit(ProfileSuccessState(userData));
    } catch (error) {
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

      if (token == null) {
        emit(ProfileErrorState(error: {
          'general': ['No token found. Please log in again.']
        }));
        return;
      }

      await DioHelper.postData(
        url: '/update-profile',
        data: data,
        token: token,
      );

      await getProfile();
    } catch (error) {
      emit(ProfileErrorState(error: {
        'general': ['Failed to update,please try again']
      }));
    }
  }
}
