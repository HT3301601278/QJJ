import 'package:flutter/material.dart';
import 'device_management_page.dart';
import 'data_management_page.dart';
import 'data_update_page.dart';
import 'alarm_management_page.dart';
import 'report_generation_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatisticsGrid(),
              const SizedBox(height: 24),
              _buildRealtimeChart(),
              const SizedBox(height: 24),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard('设备总数', '10', Icons.devices),
        _buildStatCard('在线设备', '8', Icons.cloud_done),
        _buildStatCard('离线设备', '2', Icons.cloud_off),
        _buildStatCard('报警数量', '1', Icons.warning),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRealtimeChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('实时数据', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('快速操作', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionCard('设备管理', Icons.devices, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeviceManagementPage()),
              );
            }),
            _buildActionCard('数据管理', Icons.data_usage, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataManagementPage()),
              );
            }),
            _buildActionCard('查看报警', Icons.warning, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlarmManagementPage()),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
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