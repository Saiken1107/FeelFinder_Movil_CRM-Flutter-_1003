import 'package:feelfinder_mobile/controllers/dashboard_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// final Box _boxLogin = Hive.box("login");
// String _stringNombre = "";

class _HomePageState extends State<HomePage> {
  final DashboardController _dashboardController = DashboardController();
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final data = await _dashboardController.getDashboardData();
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error al cargar los datos del dashboard")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Comparación: Cotizaciones vs Suscripciones",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildBarChart(),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Suscripciones por Tipo de Plan",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildPieChart(),
                ],
              ),
            ),
    );
  }

  Widget _buildBarChart() {
    final totalCotizaciones = _dashboardData!['totalCotizaciones'];
    final totalSuscripciones = _dashboardData!['totalSuscripciones'];

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Cotizaciones');
                    case 1:
                      return const Text('Suscripciones');
                    default:
                      return const Text('');
                  }
                },
                reservedSize: 30,
              ),
            ),
            
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [BarChartRodData(toY: totalCotizaciones.toDouble())],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [BarChartRodData(toY: totalSuscripciones.toDouble())],
              showingTooltipIndicators: [0],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final suscripcionesPorPlan = _dashboardData!['suscripcionesPorPlan'];

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: suscripcionesPorPlan.map<PieChartSectionData>((plan) {
            return PieChartSectionData(
              value: plan['cantidad'].toDouble(),
              title: plan['planNombre'],
              radius: 50,
            );
          }).toList(),
        ),
      ),
    );
  }
}
