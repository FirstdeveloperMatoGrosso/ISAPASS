import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

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
      throw AuthException(
        'Erro ao fazer login. Verifique suas credenciais.',
      );
    }
  }

  bool isAuthenticated() {
    final user = _supabase.auth.currentUser;
    _logger.fine('Checking authentication status: ${user != null}');
    return user != null;
  }
}
