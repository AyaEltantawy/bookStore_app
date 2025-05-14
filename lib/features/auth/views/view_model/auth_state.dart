class AuthStates {}

class AuthInitState extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {
  final String message;

  LoginSuccessState({required this.message});
}

class LoginErrorState extends AuthStates {
  final String error;

  LoginErrorState({required this.error});
}

class SignUpLoadingState extends AuthStates {}

class SignUpSuccessState extends AuthStates {
  final String message;
  SignUpSuccessState({required this.message});
}

class SignUpErrorState extends AuthStates {
  final Map<String, List<String>> error;

  SignUpErrorState({required this.error});
}
