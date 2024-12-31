import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/auth_service.dart';
import 'admin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2F),
      body: Row(
        children: [
          // Menu Lateral Fixo
          Container(
            width: 250,
            color: const Color(0xFF1E1E2F),
            child: Column(
              children: [
                // Cabeçalho com informações do usuário
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'admin@isapass.com',
                        style: TextStyle(
                          color: Colors.white.withAlpha(128),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Itens do Menu
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.dashboard_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Dashboard',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.event,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Eventos',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/events');
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Administração',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminScreen(),
                            ),
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Divider(color: Colors.white24),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.people_outline,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Usuários',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person_add_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Incluir Usuário',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {},
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Divider(color: Colors.white24),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Configurações',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.help_outline,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Ajuda',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {},
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Divider(color: Colors.white24),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.logout_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Sair',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          await authService.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/login');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Conteúdo Principal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Dashboard Eventos',
                    style: TextStyle(
                      color: Colors.white.withAlpha(128),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildCard(
                                icon: Icons.event,
                                value: '12',
                                label: 'Total de Eventos',
                                color: const Color(0xFF6366F1),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCard(
                                icon: Icons.confirmation_number,
                                value: '158',
                                label: 'Ingressos Vendidos',
                                color: const Color(0xFF10B981),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCard(
                                icon: Icons.people,
                                value: '1.2k',
                                label: 'Usuários Ativos',
                                color: const Color(0xFFF59E0B),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCard(
                                icon: Icons.attach_money,
                                value: 'R\$15.8k',
                                label: 'Receita Total',
                                color: const Color(0xFF3B82F6),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Análise de Dados',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                height: 350,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(13),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withAlpha(26),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Vendas Mensais',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Expanded(
                                      child: LineChart(mainData()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Container(
                                height: 350,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(13),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withAlpha(26),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Distribuição de Ingressos',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Expanded(
                                      child: PieChart(pieData()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget _buildCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Gradient gradient,
  }) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(128),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(128),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withAlpha(128),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white.withAlpha(128),
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              );
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text('\$${value.toInt()}k', style: style),
              );
            },
            reservedSize: 40,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              );
              var text = '';
              switch (value.toInt()) {
                case 0:
                  text = 'Jan';
                  break;
                case 2:
                  text = 'Fev';
                  break;
                case 4:
                  text = 'Mar';
                  break;
                case 6:
                  text = 'Abr';
                  break;
                case 8:
                  text = 'Mai';
                  break;
                case 10:
                  text = 'Jun';
                  break;
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(text, style: style),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 11,
      minY: 3,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.5),
            FlSpot(1, 4),
            FlSpot(2, 3.8),
            FlSpot(3, 3.2),
            FlSpot(4, 4.2),
            FlSpot(5, 5),
            FlSpot(6, 4.8),
            FlSpot(7, 4.2),
            FlSpot(8, 3.8),
            FlSpot(9, 3.6),
            FlSpot(10, 4.2),
            FlSpot(11, 5.8),
          ],
          isCurved: true,
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 6,
                color: Colors.white,
                strokeWidth: 3,
                strokeColor: const Color(0xFF6366F1),
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6366F1).withAlpha(128),
                const Color(0xFF8B5CF6).withAlpha(0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  PieChartData pieData() {
    return PieChartData(
      sectionsSpace: 0,
      centerSpaceRadius: 60,
      sections: [
        PieChartSectionData(
          color: const Color(0xFF6366F1),
          value: 40,
          title: '40%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: const Color(0xFF10B981),
          value: 30,
          title: '30%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: const Color(0xFFF59E0B),
          value: 30,
          title: '30%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
