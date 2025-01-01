import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_theme.dart';
import 'new_events_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = Supabase.instance.client.auth.currentUser;
  bool isExpanded = true;
  bool isLoading = false;
  final _logger = Logger('DashboardScreen');
  
  // Estados para armazenar as estatísticas
  double totalEvents = 0.0;
  double todayEvents = 0.0;
  double totalParticipants = 0.0;
  double completionRate = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }
  
  Future<void> _loadDashboardData() async {
    if (!mounted) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    
    setState(() {
      isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      
      // Criar eventos de exemplo se não existirem
      await _createSampleEvents();
      
      // Buscar total de eventos
      final response = await supabase
          .from('events')
          .select('id, start_date, status');
      
      if (!mounted) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      
      if (response.data != null) {
        final events = response.data as List;
        setState(() {
          totalEvents = events.length.toDouble();
          
          // Calcular eventos de hoje
          final today = DateTime.now();
          todayEvents = events.where((event) {
            final eventDate = DateTime.parse(event['start_date']);
            return eventDate.year == today.year &&
                   eventDate.month == today.month &&
                   eventDate.day == today.day;
          }).length.toDouble();
          
          // Calcular taxa de conclusão
          final completedEvents = events.where((event) => 
            event['status'] == 'completed').length.toDouble();
          completionRate = events.isEmpty ? 0 : 
            (completedEvents / events.length * 100);
        });
      }
      
      // Buscar total de participantes únicos
      final participantsResponse = await supabase
          .from('event_participants')
          .select('user_id');
      
      if (!mounted) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      
      if (participantsResponse.data != null) {
        final participants = participantsResponse.data as List;
        final uniqueParticipants = participants
            .map((p) => p['user_id'])
            .toSet()
            .length.toDouble();
        
        setState(() {
          totalParticipants = uniqueParticipants;
        });
      }
    } catch (e) {
      _logger.warning('Erro ao carregar dados do dashboard: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _createSampleEvents() async {
    try {
      final supabase = Supabase.instance.client;
      final eventsResponse = await supabase
          .from('events')
          .select('id');
      
      if (!mounted) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      
      if (eventsResponse.data == null || (eventsResponse.data as List).isEmpty) {
        final eventsToInsert = [
          {
            'title': 'Evento de Exemplo 1',
            'start_date': DateTime.now().add(Duration(days: 1)).toIso8601String(),
            'end_date': DateTime.now().add(Duration(days: 1, hours: 2)).toIso8601String(),
            'status': 'pending',
          },
          {
            'title': 'Evento de Exemplo 2',
            'start_date': DateTime.now().add(Duration(days: 3)).toIso8601String(),
            'end_date': DateTime.now().add(Duration(days: 3, hours: 2)).toIso8601String(),
            'status': 'pending',
          },
          {
            'title': 'Evento de Exemplo 3',
            'start_date': DateTime.now().add(Duration(days: 5)).toIso8601String(),
            'end_date': DateTime.now().add(Duration(days: 5, hours: 2)).toIso8601String(),
            'status': 'pending',
          },
        ];

        await supabase.from('events').insert(eventsToInsert);
      }
    } catch (e) {
      _logger.warning('Erro ao criar eventos de exemplo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Menu Lateral
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isExpanded ? 250 : 70,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor.withValues(
                      red: AppTheme.primaryColor.r,
                      green: AppTheme.primaryColor.g,
                      blue: AppTheme.primaryColor.b,
                      alpha: (0.1 * 255).toDouble()
                    ),
                    AppTheme.primaryColor.withAlpha(200),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Cabeçalho do Menu
                  Container(
                    height: 150,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Text(
                            user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isExpanded) ...[
                          const SizedBox(height: 12),
                          Text(
                            user?.email ?? 'Usuário',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Itens do Menu
                  _buildMenuItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    isSelected: true,
                  ),
                  _buildMenuItem(
                    icon: Icons.event,
                    title: 'Eventos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewEventsScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.analytics,
                    title: 'Análises',
                  ),
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: 'Configurações',
                  ),
                  const Spacer(),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Sair',
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      
                      try {
                        await Supabase.instance.client.auth.signOut();
                        navigator.pushReplacementNamed('/');
                      } catch (e) {
                        if (mounted) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Erro ao fazer logout'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo Principal
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Column(
                children: [
                  // Barra Superior
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            red: Colors.black.r,
                            green: Colors.black.g,
                            blue: Colors.black.b,
                            alpha: (0.1 * 255).toDouble()
                          ),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isExpanded ? Icons.menu_open : Icons.menu,
                          ),
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => _loadDashboardData(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  // Conteúdo do Dashboard
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else ...[
                            // Cards de Estatísticas
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'Total de Eventos',
                                      value: totalEvents.toString(),
                                      icon: Icons.calendar_today,
                                      color: AppTheme.primaryColor,
                                      trend: '+12%',
                                      isUp: true,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'Eventos Hoje',
                                      value: todayEvents.toString(),
                                      icon: Icons.event,
                                      color: AppTheme.primaryColor,
                                      trend: '+3%',
                                      isUp: true,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'Taxa de Conclusão',
                                      value: '${completionRate.toStringAsFixed(2)}%',
                                      icon: Icons.check_circle_outline,
                                      color: AppTheme.primaryColor,
                                      trend: '-2%',
                                      isUp: false,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'Participantes',
                                      value: totalParticipants.toString(),
                                      icon: Icons.people_outline,
                                      color: AppTheme.primaryColor,
                                      trend: '+18%',
                                      isUp: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Gráficos
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gráfico de Linha
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 400,
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            red: Colors.black.r,
                                            green: Colors.black.g,
                                            blue: Colors.black.b,
                                            alpha: (0.1 * 255).toDouble()
                                          ),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Eventos por Mês',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(Icons.more_vert),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        Expanded(
                                          child: LineChart(
                                            LineChartData(
                                              gridData: FlGridData(
                                                show: true,
                                                drawVerticalLine: false,
                                                horizontalInterval: 1,
                                                getDrawingHorizontalLine: (value) {
                                                  return FlLine(
                                                    color: Colors.grey[200],
                                                    strokeWidth: 1,
                                                  );
                                                },
                                              ),
                                              titlesData: FlTitlesData(
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    interval: 2,
                                                    reservedSize: 40,
                                                  ),
                                                ),
                                                rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(showTitles: false),
                                                ),
                                                topTitles: AxisTitles(
                                                  sideTitles: SideTitles(showTitles: false),
                                                ),
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    getTitlesWidget: (value, meta) {
                                                      const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'];
                                                      if (value.toInt() < 0 || value.toInt() >= months.length) {
                                                        return const Text('');
                                                      }
                                                      return Padding(
                                                        padding: const EdgeInsets.only(top: 8),
                                                        child: Text(
                                                          months[value.toInt()],
                                                          style: TextStyle(
                                                            color: Colors.grey[600],
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              borderData: FlBorderData(show: false),
                                              lineBarsData: [
                                                LineChartBarData(
                                                  spots: const [
                                                    FlSpot(0, 3),
                                                    FlSpot(1, 4),
                                                    FlSpot(2, 3.5),
                                                    FlSpot(3, 5),
                                                    FlSpot(4, 4),
                                                    FlSpot(5, 6),
                                                  ],
                                                  isCurved: true,
                                                  color: AppTheme.primaryColor,
                                                  barWidth: 3,
                                                  isStrokeCapRound: true,
                                                  dotData: FlDotData(
                                                    show: true,
                                                    getDotPainter: (spot, percent, barData, index) {
                                                      return FlDotCirclePainter(
                                                        radius: 4,
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                        strokeColor: AppTheme.primaryColor,
                                                      );
                                                    },
                                                  ),
                                                  belowBarData: BarAreaData(
                                                    show: true,
                                                    color: AppTheme.primaryColor.withValues(
                                                      red: AppTheme.primaryColor.r,
                                                      green: AppTheme.primaryColor.g,
                                                      blue: AppTheme.primaryColor.b,
                                                      alpha: (0.1 * 255).toDouble()
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 24),

                                // Lista de Próximos Eventos
                                Expanded(
                                  child: Container(
                                    height: 400,
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            red: Colors.black.r,
                                            green: Colors.black.g,
                                            blue: Colors.black.b,
                                            alpha: (0.1 * 255).toDouble()
                                          ),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Próximos Eventos',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: const Text('Ver Todos'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Expanded(
                                          child: ListView.separated(
                                            itemCount: 5,
                                            separatorBuilder: (context, index) => const Divider(),
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.primaryColor.withValues(
                                                      red: AppTheme.primaryColor.r,
                                                      green: AppTheme.primaryColor.g,
                                                      blue: AppTheme.primaryColor.b,
                                                      alpha: (0.1 * 255).toDouble()
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    Icons.event,
                                                    color: AppTheme.primaryColor,
                                                  ),
                                                ),
                                                title: Text(
                                                  'Evento ${index + 1}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  DateTime.now()
                                                      .add(Duration(days: index))
                                                      .toString()
                                                      .split(' ')[0],
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white70,
      ),
      title: isExpanded
          ? Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
              ),
            )
          : null,
      selected: isSelected,
      onTap: onTap,
      selectedTileColor: Colors.white.withValues(
        red: Colors.white.r,
        green: Colors.white.g,
        blue: Colors.white.b,
        alpha: (0.1 * 255).toDouble()
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: isExpanded ? 16 : 0,
        vertical: 4,
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool isUp,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              red: Colors.black.r,
              green: Colors.black.g,
              blue: Colors.black.b,
              alpha: (0.1 * 255).toDouble()
            ),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(
                    red: color.r,
                    green: color.g,
                    blue: color.b,
                    alpha: (0.1 * 255).toDouble()
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isUp ? Colors.green.withValues(
                    red: Colors.green.r,
                    green: Colors.green.g,
                    blue: Colors.green.b,
                    alpha: (0.1 * 255).toDouble()
                  ) : Colors.red.withValues(
                    red: Colors.red.r,
                    green: Colors.red.g,
                    blue: Colors.red.b,
                    alpha: (0.1 * 255).toDouble()
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isUp ? Colors.green : Colors.red,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: TextStyle(
                        color: isUp ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
