import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

class EventService {
  final _supabase = Supabase.instance.client;
  final _logger = Logger('EventService');

  Future<String?> createEvent({
    required String name,
    required String description,
    required DateTime date,
    required String location,
    required double price,
    required int maxCapacity,
    required String category,
    String? imageUrl,
    required String area,
    required String classification,
  }) async {
    try {
      final response = await _supabase.from('events').insert({
        'name': name,
        'description': description,
        'date': date.toIso8601String(),
        'location': location,
        'price': price,
        'max_capacity': maxCapacity,
        'available_tickets': maxCapacity,
        'category': category,
        'image_url': imageUrl,
        'area': area,
        'classification': classification,
        'created_by': _supabase.auth.currentUser?.id,
        'created_at': DateTime.now().toIso8601String(),
      }).select('id').single();

      _logger.info('Evento criado com sucesso: ${response['id']}');
      return response['id'];
    } catch (error) {
      _logger.severe('Erro ao criar evento', error);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      final response = await _supabase
          .from('events')
          .select('''
            *,
            tickets:event_tickets(count)
          ''')
          .order('date', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      _logger.severe('Erro ao buscar eventos', error);
      return [];
    }
  }

  Future<Map<String, dynamic>?> getEventById(String id) async {
    try {
      final response = await _supabase
          .from('events')
          .select()
          .eq('id', id)
          .single();

      return response;
    } catch (error) {
      _logger.severe('Erro ao buscar evento', error);
      return null;
    }
  }

  Future<bool> updateEvent(
    String id, {
    String? name,
    String? description,
    DateTime? date,
    String? location,
    double? price,
    int? maxCapacity,
    String? category,
    String? imageUrl,
    String? area,
    String? classification,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (date != null) 'date': date.toIso8601String(),
        if (location != null) 'location': location,
        if (price != null) 'price': price,
        if (maxCapacity != null) 'max_capacity': maxCapacity,
        if (category != null) 'category': category,
        if (imageUrl != null) 'image_url': imageUrl,
        if (area != null) 'area': area,
        if (classification != null) 'classification': classification,
      };

      await _supabase
          .from('events')
          .update(updates)
          .eq('id', id);

      _logger.info('Evento atualizado com sucesso: $id');
      return true;
    } catch (error) {
      _logger.severe('Erro ao atualizar evento', error);
      return false;
    }
  }

  Future<bool> deleteEvent(String id) async {
    try {
      await _supabase
          .from('events')
          .delete()
          .eq('id', id);

      _logger.info('Evento deletado com sucesso: $id');
      return true;
    } catch (error) {
      _logger.severe('Erro ao deletar evento', error);
      return false;
    }
  }

  Future<void> createSampleEvents() async {
    try {
      // Verificar se já existem eventos
      final events = await getEvents();
      if (events.isNotEmpty) return;

      final sampleEvents = [
        {
          'id': '1',
          'name': 'Festival de Música Eletrônica',
          'description': 'O maior festival de música eletrônica do Brasil! Com DJs internacionais e muita diversão.',
          'date': '2024-02-15',
          'location': 'Arena São Paulo',
          'price': 250.00,
          'area': 'Música, Entretenimento',
          'image_url': 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
          'created_at': '2024-01-01',
        },
        {
          'id': '2',
          'name': 'Workshop de Fotografia',
          'description': 'Aprenda técnicas avançadas de fotografia com profissionais renomados.',
          'date': '2024-02-20',
          'location': 'Centro Cultural SP',
          'price': 150.00,
          'area': 'Educação, Arte',
          'image_url': 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
          'created_at': '2024-01-01',
        },
        {
          'id': '3',
          'name': 'Stand-Up Comedy Night',
          'description': 'Uma noite de muitas risadas com os melhores comediantes do país.',
          'date': '2024-02-25',
          'location': 'Teatro Municipal',
          'price': 80.00,
          'area': 'Comédia, Entretenimento',
          'image_url': 'https://images.unsplash.com/photo-1585699324551-f6c309eedeca?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
          'created_at': '2024-01-01',
        },
        {
          'id': '4',
          'name': 'Feira Gastronômica',
          'description': 'Experimente pratos deliciosos de diversos países em um só lugar.',
          'date': '2024-03-01',
          'location': 'Parque Villa-Lobos',
          'price': 45.00,
          'area': 'Gastronomia, Cultura',
          'image_url': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
          'created_at': '2024-01-01',
        },
        {
          'id': '5',
          'name': 'Conferência de Tecnologia',
          'description': 'Descubra as últimas tendências em IA, blockchain e desenvolvimento web.',
          'date': '2024-03-10',
          'location': 'Centro de Convenções',
          'price': 350.00,
          'area': 'Tecnologia, Educação',
          'image_url': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
          'created_at': '2024-01-01',
        },
      ];

      await _supabase.from('events').insert(sampleEvents);
      _logger.info('Eventos de exemplo criados com sucesso');
    } catch (error) {
      _logger.severe('Erro ao criar eventos de exemplo', error);
    }
  }
}
