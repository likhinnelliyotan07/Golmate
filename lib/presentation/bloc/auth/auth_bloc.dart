import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../core/utils/firebase_auth_error_handler.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases authUseCases;
  StreamSubscription? _authStateSubscription;

  AuthBloc({required this.authUseCases}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<SignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<SignInWithPhoneRequested>(_onSignInWithPhoneRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<PasswordUpdateRequested>(_onPasswordUpdateRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<AccountDeletionRequested>(_onAccountDeletionRequested);

    // Listen to auth state changes
    _startAuthStateListener();
  }

  void _startAuthStateListener() {
    _authStateSubscription = authUseCases.authStateChanges.listen(
      (user) {
        if (user != null) {
          add(AuthCheckRequested());
        } else {
          add(
            AuthCheckRequested(),
          ); // This will trigger AuthLoggedOut in _onAuthCheckRequested
        }
      },
      onError: (error) {
        log('Auth state changes error: $error');
        add(
          AuthCheckRequested(),
        ); // This will trigger AuthError in _onAuthCheckRequested
      },
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authUseCases.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      log('Auth check error: $e');
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onSignInWithEmailRequested(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authUseCases.signInWithEmail(
        event.email,
        event.password,
      );
      log(user.toString());
      emit(AuthSuccess(user));
    } catch (e) {
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onSignUpWithEmailRequested(
    SignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authUseCases.signUpWithEmail(
        event.email,
        event.password,
        event.name,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onSignInWithGoogleRequested(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authUseCases.signInWithGoogle();
      emit(AuthSuccess(user));
    } catch (e) {
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onSignInWithPhoneRequested(
    SignInWithPhoneRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authUseCases.signInWithPhone(event.phoneNumber);
      emit(AuthSuccess(user));
    } catch (e) {
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authUseCases.signOut();
      emit(AuthLoggedOut());
    } catch (e) {
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authUseCases.sendPasswordResetEmail(event.email);
      emit(PasswordResetSent(event.email));
    } catch (e) {
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onPasswordUpdateRequested(
    PasswordUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authUseCases.updatePassword(event.newPassword);
      emit(AuthSuccess((state as AuthSuccess).user));
    } catch (e) {
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authUseCases.updateProfile(event.user);
      emit(ProfileUpdated(event.user));
    } catch (e) {
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onAccountDeletionRequested(
    AccountDeletionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authUseCases.deleteAccount();
      emit(AuthLoggedOut());
    } catch (e) {
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      emit(AuthError(errorMessage));
    }
  }
}
