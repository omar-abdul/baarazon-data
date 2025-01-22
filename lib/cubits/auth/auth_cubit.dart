import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/preferences_service.dart';

// Auth State
class AuthState extends Equatable {
  final String? token;
  final bool isAuthenticated;
  final String? error;

  const AuthState({
    this.token,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({
    String? token,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [token, isAuthenticated, error];
}

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final token = await PreferencesService.getToken();
    if (token != null) {
      emit(state.copyWith(token: token, isAuthenticated: true));
    }
  }

  Future<void> login(String token) async {
    try {
      await PreferencesService.setToken(token);
      emit(state.copyWith(
        token: token,
        isAuthenticated: true,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await PreferencesService.removeToken();
      emit(const AuthState());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
