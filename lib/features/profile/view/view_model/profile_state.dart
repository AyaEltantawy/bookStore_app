import 'package:flutter/foundation.dart';

@immutable
abstract class ProfileState {
  Map<String, dynamic>? get user => null;
}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final Map<String, dynamic> userData;

  ProfileSuccessState(this.userData);

  @override
  Map<String, dynamic>? get user => userData;
}
class UpdateProfileLoading extends ProfileState{}
class UpdateProfileSuccess extends ProfileState{}
class UpdateProfileFailed extends ProfileState{}
class ProfileErrorState extends ProfileState {
  final Map<String, List<String>> error;
  ProfileErrorState({required this.error});
}
