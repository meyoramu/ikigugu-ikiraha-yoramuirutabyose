import 'package:flutter_bloc/flutter_bloc.dart';

/// Base class for all authentication-related events.
abstract class AuthEvent {}

/// Event triggered when a user attempts to log in.
class LoginEvent extends AuthEvent {
  /// The username provided for authentication.
  final String username;

  /// The password provided for authentication.
  final String password;

  /// Creates a login event with the provided credentials.
  LoginEvent({required this.username, required this.password});
}

/// Event triggered when a user logs out.
class LogoutEvent extends AuthEvent {}

/// Event triggered to check the current authentication status.
class CheckAuthStatusEvent extends AuthEvent {}

/// Base class for all authentication-related states.
abstract class AuthState {}

/// Initial state when the authentication status is unknown.
class AuthInitial extends AuthState {}

/// State indicating that an authentication operation is in progress.
class AuthLoading extends AuthState {}

/// State indicating that the user is authenticated.
class AuthAuthenticated extends AuthState {
  /// The unique identifier of the authenticated user.
  final String userId;

  /// Creates an authenticated state with the user's ID.
  AuthAuthenticated({required this.userId});
}

/// State indicating that the user is not authenticated.
class AuthUnauthenticated extends AuthState {}

/// State indicating that an authentication error occurred.
class AuthError extends AuthState {
  /// The error message describing what went wrong.
  final String message;

  /// Creates an error state with the provided error message.
  AuthError({required this.message});
}

/// BLoC that manages the authentication state of the application.
///
/// Handles login, logout, and authentication status check operations.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Creates an [AuthBloc] instance.
  ///
  /// Initializes with [AuthInitial] state and sets up event handlers.
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      // Simulate authentication
      await Future<void>.delayed(const Duration(seconds: 2));
      
      // For demo purposes, always authenticate with a dummy user ID
      emit(AuthAuthenticated(userId: 'user-123'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      // Simulate logout
      await Future<void>.delayed(const Duration(seconds: 1));
      
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      // Simulate checking auth status
      await Future<void>.delayed(const Duration(seconds: 1));
      
      // For demo purposes, always unauthenticated initially
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}