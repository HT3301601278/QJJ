import 'package:flutter/material.dart';
import 'device_management_page.dart';
import 'data_management_page.dart';
import 'data_update_page.dart';
import 'alarm_management_page.dart';
import 'report_generation_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<FlSpot> _realtimeData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRealtimeDataSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('仪表盘'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatisticsCards(),
            const SizedBox(height: 24),
            _buildRealtimeChart(),
            const SizedBox(height: 24),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard('设备总数', '10'),
        _buildStatCard('在线设备', '8'),
        _buildStatCard('离线设备', '2'),
        _buildStatCard('报警数量', '1'),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRealtimeChart() {
    return Container(
      height: 200,
      child: _realtimeData.isEmpty
        ? Center(child: Text('暂无数据'))
        : LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: true),
              minX: 0,
              maxX: 20,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: _realtimeData,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DeviceManagementPage()),
            );
          },
          child: const Text('设备管理'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DataManagementPage()),
            );
          },
          child: const Text('数据管理'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DataUpdatePage()),
            );
          },
          child: const Text('数据更新'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlarmManagementPage()),
            );
          },
          child: const Text('查看报警'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportGenerationPage()),
            );
          },
          child: const Text('报表生成'),
        ),
      ],
    );
  }

  void _startRealtimeDataSimulation() {
    final random = Random();
    _realtimeData = List.generate(20, (index) => FlSpot(index.toDouble(), random.nextDouble() * 5 + 5));
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _realtimeData.removeAt(0);
        _realtimeData.add(FlSpot(20, random.nextDouble() * 5 + 5));
        for (int i = 0; i < _realtimeData.length; i++) {
          _realtimeData[i] = FlSpot(i.toDouble(), _realtimeData[i].y);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}