import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

class TicketService {
  final _supabase = Supabase.instance.client;
  final _logger = Logger('TicketService');

  Future<void> purchaseTicket(String eventId, String userId) async {
    try {
      // Check ticket availability
      final event = await _supabase
          .from('events')
          .select('available_tickets')
          .eq('id', eventId)
          .single();

      if (event['available_tickets'] <= 0) {
        throw Exception('Sold out');
      }

      // Start transaction
      await _supabase.rpc('purchase_ticket', params: {
        'event_id': eventId,
        'user_id': userId,
      });

      _logger.info('Ticket purchased successfully: eventId=$eventId, userId=$userId');
    } catch (error) {
      _logger.severe('Error purchasing ticket: $error');
      if (error.toString().contains('Sold out')) {
        rethrow;
      }
      throw Exception('Error processing purchase. Please try again.');
    }
  }

  Future<List<Map<String, dynamic>>> getUserTickets(String userId) async {
    try {
      final tickets = await _supabase
          .from('tickets')
          .select('*, events(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(tickets);
    } catch (error) {
      _logger.severe('Error fetching user tickets: $error');
      throw Exception('Error loading your tickets');
    }
  }
}
