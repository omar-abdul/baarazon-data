import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../logger.dart';
import '../../services/preferences_service.dart';
import '../../services/auth_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  otpSent,
  error,
}

// Auth State
class AuthState extends Equatable {
  final String? token;
  final AuthStatus status;
  final String? error;

  const AuthState({
    this.token,
    this.status = AuthStatus.initial,
    this.error,
  });

  AuthState copyWith({
    String? token,
    AuthStatus? status,
    String? error,
  }) {
    return AuthState(
      token: token ?? this.token,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [token, status, error];
}

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  final _authService = AuthService();

  AuthCubit() : super(const AuthState()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final token = await PreferencesService.getToken();
    if (token != null) {
      emit(state.copyWith(token: token, status: AuthStatus.authenticated));
    }
  }

  Future<void> loginWithPhone(String phoneNumber) async {
    try {
      logger.d('loginWithPhone: $phoneNumber');
      emit(state.copyWith(status: AuthStatus.loading));
      final response = await _authService.login(phoneNumber);
      if (response == null) {
        emit(state.copyWith(status: AuthStatus.otpSent, error: null));
      } else {
        emit(state.copyWith(
            status: AuthStatus.error,
            error: "There was an error sending the OTP"));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      ));
    }
  }

  void verifyOtp(String otp) async {
    try {
      final response = await _authService.verifyOtp(otp);
      if (response["token"] != null) {
        emit(state.copyWith(
            status: AuthStatus.authenticated, token: response["token"]));
      } else {
        emit(
            state.copyWith(status: AuthStatus.error, error: response["error"]));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      emit(const AuthState());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
