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
  DateTime? _selectedDate;

  final List<String> _categories = [
    'Todos',
    'Shows',
    'Teatro',
    'Esportes',
    'Festivais',
    'Outros'
  ];

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
      debugPrint('Erro ao carregar eventos: $e');
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
      debugPrint('Erro ao carregar favoritos: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites', _favoriteEvents.toList());
    } catch (e) {
      debugPrint('Erro ao salvar favoritos: $e');
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

  void _filterEvents() {
    setState(() {
      _filteredEvents = _events.where((event) {
        final matchesSearch = event['name'].toString().toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
        
        final matchesCategory = _selectedCategory == 'Todos' ||
            event['category'] == _selectedCategory;

        final eventDate = DateTime.parse(event['date']);
        final matchesDate = _selectedDate == null ||
            (eventDate.year == _selectedDate!.year &&
             eventDate.month == _selectedDate!.month &&
             eventDate.day == _selectedDate!.day);

        return matchesSearch && matchesCategory && matchesDate;
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6C63FF),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E2F),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _filterEvents();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2F),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1E1E2F),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    red: Colors.white.r,
                    green: Colors.white.g,
                    blue: Colors.white.b,
                    alpha: (0.1 * 255).toDouble()
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Eventos',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF6C63FF).withValues(
                        red: Color(0xFF6C63FF).r,
                        green: Color(0xFF6C63FF).g,
                        blue: Color(0xFF6C63FF).b,
                        alpha: (0.2 * 255).toDouble()
                      ),
                      const Color(0xFF1E1E2F),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      red: Colors.white.r,
                      green: Colors.white.g,
                      blue: Colors.white.b,
                      alpha: (0.1 * 255).toDouble()
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
                onPressed: () => Navigator.pushNamed(context, '/create-event'),
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16 : size.width * 0.1,
                  ),
                  child: Container(
                    height: 56,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        red: Colors.white.r,
                        green: Colors.white.g,
                        blue: Colors.white.b,
                        alpha: (0.1 * 255).toDouble()
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Icon(
                          Icons.search,
                          color: Colors.white.withValues(
                            red: Colors.white.r,
                            green: Colors.white.g,
                            blue: Colors.white.b,
                            alpha: (0.7 * 255).toDouble()
                          ),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Buscar eventos...',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(
                                  red: Colors.white.r,
                                  green: Colors.white.g,
                                  blue: Colors.white.b,
                                  alpha: (0.5 * 255).toDouble()
                                ),
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) => _filterEvents(),
                          ),
                        ),
                        Container(
                          height: 24,
                          width: 1,
                          color: Colors.white.withValues(
                            red: Colors.white.r,
                            green: Colors.white.g,
                            blue: Colors.white.b,
                            alpha: (0.2 * 255).toDouble()
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            color: _selectedDate != null
                                ? const Color(0xFF6C63FF)
                                : Colors.white.withValues(
                                  red: Colors.white.r,
                                  green: Colors.white.g,
                                  blue: Colors.white.b,
                                  alpha: (0.7 * 255).toDouble()
                                ),
                            size: 20,
                          ),
                          onPressed: () => _selectDate(context),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16 : size.width * 0.1,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCategory = isSelected ? 'Todos' : category;
                                _filterEvents();
                              });
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF6C63FF)
                                    : Colors.white.withValues(
                                      red: Colors.white.r,
                                      green: Colors.white.g,
                                      blue: Colors.white.b,
                                      alpha: (0.1 * 255).toDouble()
                                    ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(
                                        red: Colors.white.r,
                                        green: Colors.white.g,
                                        blue: Colors.white.b,
                                        alpha: (0.7 * 255).toDouble()
                                      ),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                ),
              ),
            )
          else if (_filteredEvents.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          red: Colors.white.r,
                          green: Colors.white.g,
                          blue: Colors.white.b,
                          alpha: (0.1 * 255).toDouble()
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.event_busy,
                        size: 48,
                        color: Colors.white.withValues(
                          red: Colors.white.r,
                          green: Colors.white.g,
                          blue: Colors.white.b,
                          alpha: (0.7 * 255).toDouble()
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Nenhum evento encontrado',
                      style: TextStyle(
                        color: Colors.white.withValues(
                          red: Colors.white.r,
                          green: Colors.white.g,
                          blue: Colors.white.b,
                          alpha: (0.9 * 255).toDouble()
                        ),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tente mudar seus filtros de busca',
                      style: TextStyle(
                        color: Colors.white.withValues(
                          red: Colors.white.r,
                          green: Colors.white.g,
                          blue: Colors.white.b,
                          alpha: (0.7 * 255).toDouble()
                        ),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : size.width * 0.1,
                vertical: 24,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size.width > 1200 ? 3 : (size.width > 800 ? 2 : 1),
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final event = _filteredEvents[index];
                    final date = DateTime.parse(event['date']);
                    final isFavorite = _favoriteEvents.contains(event['id']);

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/event-details',
                          arguments: event['id'],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(
                                  red: Colors.white.r,
                                  green: Colors.white.g,
                                  blue: Colors.white.b,
                                  alpha: (0.1 * 255).toDouble()
                                ),
                                Colors.white.withValues(
                                  red: Colors.white.r,
                                  green: Colors.white.g,
                                  blue: Colors.white.b,
                                  alpha: (0.05 * 255).toDouble()
                                ),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(
                                red: Colors.white.r,
                                green: Colors.white.g,
                                blue: Colors.white.b,
                                alpha: (0.1 * 255).toDouble()
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            event['image_url'] ?? 'https://via.placeholder.com/400x225',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(
                                              red: Colors.black.r,
                                              green: Colors.black.g,
                                              blue: Colors.black.b,
                                              alpha: (0.8 * 255).toDouble()
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            red: Colors.black.r,
                                            green: Colors.black.g,
                                            blue: Colors.black.b,
                                            alpha: (0.5 * 255).toDouble()
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: isFavorite ? Colors.red : Colors.white,
                                            size: 20,
                                          ),
                                          onPressed: () => _toggleFavorite(event['id']),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 16,
                                      left: 16,
                                      right: 16,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event['name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: event['available_tickets'] > 0
                                                      ? Colors.green.withValues(
                                                        red: Colors.green.r,
                                                        green: Colors.green.g,
                                                        blue: Colors.green.b,
                                                        alpha: (0.9 * 255).toDouble()
                                                      )
                                                      : Colors.red.withValues(
                                                        red: Colors.red.r,
                                                        green: Colors.red.g,
                                                        blue: Colors.red.b,
                                                        alpha: (0.9 * 255).toDouble()
                                                      ),
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      event['available_tickets'] > 0
                                                          ? Icons.check_circle
                                                          : Icons.cancel,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      event['available_tickets'] > 0
                                                          ? 'Disponível'
                                                          : 'Esgotado',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withValues(
                                                    red: Colors.black.r,
                                                    green: Colors.black.g,
                                                    blue: Colors.black.b,
                                                    alpha: (0.5 * 255).toDouble()
                                                  ),
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.calendar_today,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      DateFormat('dd/MM').format(date),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
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
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 20,
                                      color: Colors.white.withValues(
                                        red: Colors.white.r,
                                        green: Colors.white.g,
                                        blue: Colors.white.b,
                                        alpha: (0.7 * 255).toDouble()
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        event['location'],
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            red: Colors.white.r,
                                            green: Colors.white.g,
                                            blue: Colors.white.b,
                                            alpha: (0.7 * 255).toDouble()
                                          ),
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          red: Colors.white.r,
                                          green: Colors.white.g,
                                          blue: Colors.white.b,
                                          alpha: (0.1 * 255).toDouble()
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        DateFormat('HH:mm').format(date),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _filteredEvents.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              Color(0xFF6C63FF).withValues(
                red: Color(0xFF6C63FF).r,
                green: Color(0xFF6C63FF).g,
                blue: Color(0xFF6C63FF).b,
                alpha: (1 * 255).toDouble()
              ),
              Color(0xFF5A52CC).withValues(
                red: Color(0xFF5A52CC).r,
                green: Color(0xFF5A52CC).g,
                blue: Color(0xFF5A52CC).b,
                alpha: (1 * 255).toDouble()
              ),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6C63FF).withValues(
                red: Color(0xFF6C63FF).r,
                green: Color(0xFF6C63FF).g,
                blue: Color(0xFF6C63FF).b,
                alpha: (0.3 * 255).toDouble()
              ),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, '/create-event'),
            borderRadius: BorderRadius.circular(28),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Novo Evento',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
