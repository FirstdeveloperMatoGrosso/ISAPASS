import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

class SeedService {
  final _supabase = Supabase.instance.client;
  final _logger = Logger('SeedService');

  Future<void> seedEvents() async {
    try {
      // Lista de eventos de exemplo
      final events = [
        {
          'name': 'Show do Embaixador',
          'description': 'O maior show de sertanejo do ano! Venha curtir uma noite inesquecível com o Embaixador.',
          'date': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
          'location': 'Arena Fonte Nova, Salvador',
          'price': 150.0,
          'max_capacity': 1000,
          'available_tickets': 800,
          'category': 'Shows',
          'image_url': 'https://picsum.photos/500/300',
        },
        {
          'name': 'Festival de Teatro',
          'description': 'Festival com as melhores peças teatrais da cidade. Programação especial para toda a família.',
          'date': DateTime.now().add(const Duration(days: 15)).toIso8601String(),
          'location': 'Teatro Castro Alves, Salvador',
          'price': 80.0,
          'max_capacity': 500,
          'available_tickets': 350,
          'category': 'Teatro',
          'image_url': 'https://picsum.photos/500/301',
        },
        {
          'name': 'Festa de Ano Novo',
          'description': 'A maior festa de réveillon da cidade! Shows ao vivo, open bar e muito mais.',
          'date': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          'location': 'Wet\'n Wild, Salvador',
          'price': 200.0,
          'max_capacity': 2000,
          'available_tickets': 0, // Esgotado
          'category': 'Festas',
          'image_url': 'https://picsum.photos/500/302',
        },
        {
          'name': 'Campeonato de Futebol',
          'description': 'Final do campeonato baiano de futebol. Bahia x Vitória, o clássico dos clássicos!',
          'date': DateTime.now().add(const Duration(days: 45)).toIso8601String(),
          'location': 'Arena Fonte Nova, Salvador',
          'price': 100.0,
          'max_capacity': 1500,
          'available_tickets': 750,
          'category': 'Esportes',
          'image_url': 'https://picsum.photos/500/303',
        },
        {
          'name': 'Show de Stand Up',
          'description': 'Uma noite de muitas risadas com os melhores comediantes do Brasil.',
          'date': DateTime.now().add(const Duration(days: 20)).toIso8601String(),
          'location': 'Teatro SESC, Salvador',
          'price': 60.0,
          'max_capacity': 300,
          'available_tickets': 150,
          'category': 'Shows',
          'image_url': 'https://picsum.photos/500/304',
        },
      ];

      // Inserir eventos
      await _supabase.from('events').upsert(
        events,
        onConflict: 'name', // Evita duplicatas pelo nome
      );

      _logger.info('Eventos de exemplo criados com sucesso!');
    } catch (error) {
      _logger.severe('Erro ao criar eventos de exemplo', error);
      rethrow;
    }
  }
}
