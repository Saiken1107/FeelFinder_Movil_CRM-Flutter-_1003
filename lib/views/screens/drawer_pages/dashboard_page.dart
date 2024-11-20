import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tablero')),
      body: Column(
        children: [
          const Text('Leads Concretados vs Cerrados'),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: _createSampleData(),
                borderData: FlBorderData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(showTitles: true),
                  bottomTitles: SideTitles(showTitles: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _createSampleData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(y: 50, colors: [Colors.blue]),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(y: 30, colors: [Colors.red]),
        ],
      ),
    ];
  }
}
