import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

final _logger = Logger('TestUser');

class TestUser {
  static const String email = 'teste@teste.com';
  static const String password = '123456';
  
  // Prevent instantiation
  TestUser._();

  static Future<void> createTestEvents() async {
    final supabase = Supabase.instance.client;

    final testEvents = [
      {
        'name': 'Show do Metallica',
        'description': 'Show da turnê mundial M72',
        'date': '2025-03-15T20:00:00',
        'location': 'Morumbi, São Paulo',
        'category': 'Shows',
        'available_tickets': 1000,
        'image_url': 'https://i.imgur.com/QN2BSdJ.jpg',
      },
      {
        'name': 'Hamlet - Teatro Municipal',
        'description': 'Clássico de Shakespeare',
        'date': '2025-02-20T19:30:00',
        'location': 'Teatro Municipal, Rio de Janeiro',
        'category': 'Teatro',
        'available_tickets': 200,
        'image_url': 'https://i.imgur.com/7ZbXK3N.jpg',
      },
      {
        'name': 'Final Libertadores 2025',
        'description': 'Final do principal torneio da América do Sul',
        'date': '2025-11-30T17:00:00',
        'location': 'Maracanã, Rio de Janeiro',
        'category': 'Esportes',
        'available_tickets': 0,
        'image_url': 'https://i.imgur.com/XYZ9J2K.jpg',
      },
      {
        'name': 'Lollapalooza 2025',
        'description': 'O maior festival de música do Brasil',
        'date': '2025-03-22T11:00:00',
        'location': 'Autódromo de Interlagos, São Paulo',
        'category': 'Festivais',
        'available_tickets': 5000,
        'image_url': 'https://i.imgur.com/ABC123D.jpg',
      },
      {
        'name': 'Stand Up Comedy Night',
        'description': 'Noite de comédia com os melhores comediantes',
        'date': '2025-02-14T21:00:00',
        'location': 'Teatro Rival, Rio de Janeiro',
        'category': 'Outros',
        'available_tickets': 150,
        'image_url': 'https://i.imgur.com/DEF456G.jpg',
      }
    ];

    // Limpa eventos existentes
    await supabase.from('events').delete().neq('id', 0);

    // Insere novos eventos
    for (final event in testEvents) {
      await supabase.from('events').insert(event);
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://oldbtuwiwhcwbotlrdck.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9sZGJ0dXdpd2hjd2JvdGxyZGNrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU1NjEzNjAsImV4cCI6MjA1MTEzNzM2MH0.9ekS4_Oh36dKFel_lJVS7BApTujCBfEtIvZnFShxlgY',
  );

  try {
    final response = await Supabase.instance.client.auth.signUp(
      email: TestUser.email,
      password: TestUser.password,
    );
    _logger.info('Usuário criado com sucesso: ${response.user?.email}');
    await TestUser.createTestEvents();
  } catch (error) {
    _logger.severe('Erro ao criar usuário: $error');
  }
}
