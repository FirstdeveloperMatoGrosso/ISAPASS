import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/events_screen.dart';
import 'screens/admin_screen.dart';
import 'constants/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  await Supabase.initialize(
    url: 'https://oldbtuwiwhcwbotlrdck.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9sZGJ0dXdpd2hjd2JvdGxyZGNrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU1NjEzNjAsImV4cCI6MjA1MTEzNzM2MH0.9ekS4_Oh36dKFel_lJVS7BApTujCBfEtIvZnFShxlgY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IsaPass',
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/events': (context) => const EventsScreen(),
        '/admin': (context) => AdminScreen(),
      },
    );
  }
}
