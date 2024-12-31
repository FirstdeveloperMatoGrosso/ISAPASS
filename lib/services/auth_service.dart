import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import '../exceptions/custom_auth_exception.dart';

class AuthService {
  final _supabase = Supabase.instance.client;
  final _logger = Logger('AuthService');

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _logger.info('User signed out successfully');
    } catch (error) {
      _logger.severe('Error signing out', error);
      rethrow;
    }
  }

  // Alias for backward compatibility
  Future<void> logout() => signOut();

  Future<void> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _logger.info('User logged in successfully: ${response.user?.email}');
    } catch (error) {
      _logger.warning('Login failed', error);
      throw const CustomAuthException(
        'Erro ao fazer login. Verifique suas credenciais.',
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
        redirectTo: 'io.supabase.isapass://reset-callback/',
      );
      _logger.info('Password reset email sent to: $email');
    } catch (error) {
      _logger.severe('Error sending password reset email', error);
      throw const CustomAuthException(
        'Erro ao enviar email de recuperação. Tente novamente mais tarde.',
      );
    }
  }
}
