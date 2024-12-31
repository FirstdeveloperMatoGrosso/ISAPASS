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
        'created_by': _supabase.auth.currentUser?.id,
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

      // Calcular ingressos disponíveis
      return List<Map<String, dynamic>>.from(response).map((event) {
        final ticketsSold = event['tickets']?[0]?['count'] ?? 0;
        return {
          ...event,
          'available_tickets': event['max_capacity'] - ticketsSold,
        };
      }).toList();
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
}
