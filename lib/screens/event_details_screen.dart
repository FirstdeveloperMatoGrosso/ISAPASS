import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Evento'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.event['image_url'] != null)
              Image.network(
                widget.event['image_url'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event['name'] ?? '',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd/MM/yyyy').format(
                          DateTime.parse(widget.event['date']),
                        ),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.event['location'] ?? '',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Descrição',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event['description'] ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Preço',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(
                      'R\$ ${widget.event['price']?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.green.withAlpha(51),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Áreas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (widget.event['area'] as String)
                        .split(',')
                        .map((area) => Chip(
                              label: Text(area.trim()),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withAlpha(51),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.event['available_tickets'] > 0
                        ? () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            final navigator = Navigator.of(context);
                            
                            try {
                              // Atualiza o número de ingressos disponíveis
                              await Supabase.instance.client
                                .from('events')
                                .update({ 'available_tickets': widget.event['available_tickets'] - 1 })
                                .eq('id', widget.event['id']);

                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Ingresso comprado com sucesso!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                navigator.pop();
                              }
                            } catch (e) {
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Erro ao comprar ingresso. Tente novamente.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          widget.event['available_tickets'] > 0
                            ? 'Comprar Ingresso - R\$ ${widget.event['price'].toStringAsFixed(2)}'
                            : 'Esgotado',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
