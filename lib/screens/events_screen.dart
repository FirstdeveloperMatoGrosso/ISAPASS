import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _filteredEvents = [];
  Set<String> _favoriteEvents = {};
  String _selectedCategory = 'Todos';
  
  @override
  void initState() {
    super.initState();
    _loadEvents();
    _loadFavorites();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await Supabase.instance.client
          .from('events')
          .select()
          .order('date');
      
      _events = List<Map<String, dynamic>>.from(response);
      _filterEvents();
    } catch (e) {
      debugPrint('Error loading events: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _favoriteEvents = (prefs.getStringList('favorites') ?? []).toSet();
      });
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites', _favoriteEvents.toList());
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  void _toggleFavorite(String eventId) {
    setState(() {
      if (_favoriteEvents.contains(eventId)) {
        _favoriteEvents.remove(eventId);
      } else {
        _favoriteEvents.add(eventId);
      }
    });
    _saveFavorites();
  }

  void _onSearchChanged(String query) {
    _filterEvents();
  }

  void _filterEvents() {
    setState(() {
      _filteredEvents = _events.where((event) {
        final matchesSearch = event['name'].toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
        final matchesCategory = _selectedCategory == 'Todos' ||
            event['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2F),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Events',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/create-event'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search events...',
                      hintStyle: TextStyle(color: Colors.white.withAlpha(128)),
                      prefixIcon: Icon(Icons.search, color: Colors.white.withAlpha(128)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                Container(
                  height: 48,
                  width: 1,
                  color: Colors.white.withAlpha(26),
                ),
                IconButton(
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.white.withAlpha(128),
                  ),
                  onPressed: () {
                    // Location filter will be implemented later
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Shows', false),
                _buildFilterChip('Theater', false),
                _buildFilterChip('Sports', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_filteredEvents.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 64,
                      color: Colors.white.withAlpha(128),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No events found',
                      style: TextStyle(
                        color: Colors.white.withAlpha(179),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try changing your search filters',
                      style: TextStyle(
                        color: Colors.white.withAlpha(128),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = _filteredEvents[index];
                  final date = DateTime.parse(event['date']);
                  final isFavorite = _favoriteEvents.contains(event['id']);
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: Colors.white.withAlpha(13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/event-details',
                        arguments: event['id'],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    event['image_url'] ?? 'https://via.placeholder.com/400x225',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[900],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.white54,
                                          size: 48,
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withAlpha(179),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: IconButton(
                                      icon: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : Colors.white,
                                      ),
                                      onPressed: () => _toggleFavorite(event['id']),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: event['available_tickets'] > 0
                                            ? Colors.green.withAlpha(230)
                                            : Colors.red.withAlpha(230),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        event['available_tickets'] > 0
                                            ? 'Available'
                                            : 'Sold Out',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.white.withAlpha(179),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('dd/MM').format(date),
                                      style: TextStyle(
                                        color: Colors.white.withAlpha(179),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Colors.white.withAlpha(179),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        event['location'],
                                        style: TextStyle(
                                          color: Colors.white.withAlpha(179),
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-event'),
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withAlpha(179),
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: isSelected 
            ? const Color(0xFF6C63FF)
            : Colors.white.withAlpha(26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected 
                ? const Color(0xFF6C63FF)
                : Colors.white.withAlpha(26),
          ),
        ),
        onSelected: (selected) {
          setState(() => _selectedCategory = label);
          _filterEvents();
        },
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
