import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DataManagementPage extends StatefulWidget {
  const DataManagementPage({Key? key}) : super(key: key);

  @override
  _DataManagementPageState createState() => _DataManagementPageState();
}

class _DataManagementPageState extends State<DataManagementPage> {
  final List<String> _devices = ['设备1', '设备2', '设备3'];
  String _selectedDevice = '设备1';
  bool _autoRefresh = false;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('数据管理'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '实时数据'),
              Tab(text: '历史数据'),
              Tab(text: '数据可视化'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRealTimeDataTab(),
            _buildHistoricalDataTab(),
            _buildDataVisualizationTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildRealTimeDataTab() {
    return Column(
      children: [
        _buildDeviceSelector(),
        Switch(
          value: _autoRefresh,
          onChanged: (value) {
            setState(() {
              _autoRefresh = value;
            });
            // TODO: 实现自动刷新逻辑
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
        Expanded(
          child: _buildDataTable(),
        ),
      ],
    );
  }

  Widget _buildHistoricalDataTab() {
    return Column(
      children: [
        _buildDeviceSelector(),
        _buildDateRangePicker(),
        Expanded(
          child: _buildDataTable(),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: 实现导出功能
          },
          child: const Text('导出数据'),
        ),
      ],
    );
  }

  Widget _buildDataVisualizationTab() {
    return Column(
      children: [
        _buildDeviceSelector(),
        _buildDateRangePicker(),
        _buildChartTypeSelector(),
        Expanded(
          child: _buildChart(),
        ),
      ],
    );
  }

  Widget _buildDeviceSelector() {
    return DropdownButton<String>(
      value: _selectedDevice,
      onChanged: (String? newValue) {
        setState(() {
          _selectedDevice = newValue!;
        });
      },
      items: _devices.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildDateRangePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _startDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _startDate = picked;
              });
            }
          },
          child: Text('开始日期: ${_startDate.toString().substring(0, 10)}'),
        ),
        TextButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _endDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _endDate = picked;
              });
            }
          },
          child: Text('结束日期: ${_endDate.toString().substring(0, 10)}'),
        ),
      ],
    );
  }

  Widget _buildChartTypeSelector() {
    // TODO: 实现图表类型选择器
    return Container();
  }

  Widget _buildDataTable() {
    // TODO: 实现数据表格
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('数据 $index'),
          subtitle: Text('时间: ${DateTime.now().toString()}'),
        );
      },
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 7,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3),
              FlSpot(1, 1),
              FlSpot(2, 4),
              FlSpot(3, 2),
              FlSpot(4, 5),
              FlSpot(5, 1),
              FlSpot(6, 4),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}