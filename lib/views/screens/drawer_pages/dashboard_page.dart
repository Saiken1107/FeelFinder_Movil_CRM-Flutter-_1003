import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../services/tablero_rendimiento_service.dart';
import '../../../models/tablero_rendimiento.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<TableroRendimiento> _fetchData() async {
    final servicio = TableroRendimientoServicio();
    return await servicio.obtenerTableroRendimiento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tablero')),
      body: FutureBuilder<TableroRendimiento>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Leads Concretados vs Cerrados',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: _createBarGroups(data),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: SideTitles(
                          showTitles: true,
                          interval: 10,
                           getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTitles: (value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Concretados';
                              case 1:
                                return 'Cerrados';
                              default:
                                return '';
                            }
                          },
                          getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No hay datos disponibles.'));
          }
        },
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(TableroRendimiento data) {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            y: data.leadsConcretados.toDouble(),
            colors: [Colors.blue],
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            y: data.leadsCerrados.toDouble(),
            colors: [Colors.red],
          ),
        ],
      ),
    ];
  }
}
