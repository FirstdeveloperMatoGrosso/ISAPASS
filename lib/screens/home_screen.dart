import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2F),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.white.withAlpha(13),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E1E2F),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6C63FF).withAlpha(179),
                    const Color(0xFF4CAF50).withAlpha(179),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'admin@isapass.com',
                    style: TextStyle(
                      color: Colors.white.withAlpha(179),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.white),
              title: Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white.withAlpha(230),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event, color: Colors.white),
              title: Text(
                'Events',
                style: TextStyle(
                  color: Colors.white.withAlpha(230),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: Text(
                'Users',
                style: TextStyle(
                  color: Colors.white.withAlpha(230),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white.withAlpha(230),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(constraints.maxWidth > 600 ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _calculateCrossAxisCount(constraints.maxWidth),
                      crossAxisSpacing: constraints.maxWidth > 600 ? 24 : 16,
                      mainAxisSpacing: constraints.maxWidth > 600 ? 24 : 16,
                      childAspectRatio: constraints.maxWidth > 600 ? 1.5 : 1.3,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final items = [
                        {
                          'title': 'Total Events',
                          'value': '12',
                          'icon': Icons.event,
                          'color': const Color(0xFF6C63FF),
                        },
                        {
                          'title': 'Tickets Sold',
                          'value': '158',
                          'icon': Icons.confirmation_number,
                          'color': const Color(0xFF4CAF50),
                        },
                        {
                          'title': 'Active Users',
                          'value': '1.2k',
                          'icon': Icons.people,
                          'color': const Color(0xFFFFA726),
                        },
                        {
                          'title': 'Total Revenue',
                          'value': '\$15.8k',
                          'icon': Icons.attach_money,
                          'color': const Color(0xFF66BB6A),
                        },
                      ];

                      return _buildCard(
                        title: items[index]['title'] as String,
                        value: items[index]['value'] as String,
                        icon: items[index]['icon'] as IconData,
                        color: items[index]['color'] as Color,
                        constraints: constraints,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  _buildChartSection(constraints),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildChartSection(BoxConstraints constraints) {
    final isSmallScreen = constraints.maxWidth <= 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Analysis',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: isSmallScreen ? 16 : 24,
          runSpacing: isSmallScreen ? 16 : 24,
          children: [
            _buildChartCard(
              title: 'Monthly Sales',
              width: _calculateChartWidth(constraints.maxWidth),
              height: 300,
              chart: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}k',
                            style: TextStyle(
                              color: Colors.white.withAlpha(179),
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'];
                          if (value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: TextStyle(
                                color: Colors.white.withAlpha(179),
                                fontSize: 12,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
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
                      color: const Color(0xFF6C63FF),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF6C63FF).withAlpha(51),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildChartCard(
              title: 'Ticket Distribution',
              width: _calculateChartWidth(constraints.maxWidth),
              height: 300,
              chart: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
                  sections: [
                    PieChartSectionData(
                      color: const Color(0xFF6C63FF),
                      value: 40,
                      title: '40%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: const Color(0xFF4CAF50),
                      value: 30,
                      title: '30%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: const Color(0xFFFFA726),
                      value: 30,
                      title: '30%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartCard({
    required String title,
    required double width,
    required double height,
    required Widget chart,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(child: chart),
        ],
      ),
    );
  }

  double _calculateChartWidth(double screenWidth) {
    if (screenWidth > 1200) return (screenWidth - 72) / 2;
    if (screenWidth > 900) return (screenWidth - 72) / 2;
    if (screenWidth > 600) return screenWidth - 48;
    return screenWidth - 32;
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required BoxConstraints constraints,
  }) {
    final isSmallScreen = constraints.maxWidth <= 600;
    final double iconSize = isSmallScreen ? 32 : 40;
    final double fontSize = isSmallScreen ? 20 : 24;
    final double subtitleSize = isSmallScreen ? 12 : 14;
    final EdgeInsets padding = isSmallScreen 
        ? const EdgeInsets.all(16)
        : const EdgeInsets.all(24);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withAlpha(179),
            color.withAlpha(128),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withAlpha(179),
              fontSize: subtitleSize,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
