import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import '../exceptions/custom_auth_exception.dart';

class AuthService {
  final _supabase = Supabase.instance.client;
  final _logger = Logger('AuthService');

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const CustomAuthException(
          'Invalid credentials. Please check your email and password.',
        );
      }

      _logger.info('User signed in successfully: ${response.user?.email}');
      return response;
    } catch (error) {
      _logger.warning('Sign in failed', error);
      if (error is AuthException && error.message.contains('Email not confirmed')) {
        rethrow;
      }
      throw const CustomAuthException(
        'Failed to sign in. Please check your credentials.',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _logger.info('User signed out successfully');
    } catch (error) {
      _logger.severe('Error signing out', error);
      throw const CustomAuthException(
        'Failed to sign out. Please try again.',
      );
    }
  }

  // Alias for backward compatibility
  Future<void> logout() => signOut();

  Future<AuthResponse> signUp(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const CustomAuthException(
          'Failed to create account. Please try again.',
        );
      }

      _logger.info('User signed up successfully: ${response.user?.email}');
      return response;
    } catch (error) {
      _logger.warning('Sign up failed', error);
      throw const CustomAuthException(
        'Failed to create account. Please try again later.',
      );
    }
  }

  bool isAuthenticated() {
    final user = _supabase.auth.currentUser;
    _logger.fine('Checking authentication status: ${user != null}');
    return user != null;
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'https://oldbtuwiwhcwbotlrdck.supabase.co/auth/v1/callback',
      );
      _logger.info('Password reset email sent to $email');
    } catch (error) {
      _logger.severe('Error sending password reset email: $error');
      throw CustomAuthException(
        'Error sending password reset email. Please try again.',
      );
    }
  }

  Future<void> resendConfirmationEmail(String email) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      _logger.info('Confirmation email resent to: $email');
    } catch (error) {
      _logger.severe('Error resending confirmation email', error);
      throw const CustomAuthException(
        'Failed to resend confirmation email. Please try again later.',
      );
    }
  }
}
