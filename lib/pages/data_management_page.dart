import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class DataManagementPage extends StatefulWidget {
  const DataManagementPage({Key? key}) : super(key: key);

  @override
  _DataManagementPageState createState() => _DataManagementPageState();
}

class _DataManagementPageState extends State<DataManagementPage> {
  List<Map<String, dynamic>> _devices = [];
  String _selectedDevice = '';
  bool _autoRefresh = false;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/devices'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
        if (responseData.containsKey('content') && responseData['content'] is List) {
          final List<dynamic> devicesJson = responseData['content'];
          setState(() {
            _devices = devicesJson.cast<Map<String, dynamic>>();
            if (_devices.isNotEmpty) {
              _selectedDevice = _devices[0]['id'].toString();
            }
            _isLoading = false;
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load devices');
      }
    } catch (e) {
      print('Error fetching devices: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8080/api/devices/$_selectedDevice/data?page=0&size=10&startTime=${_startDate.toIso8601String()}&endTime=${_endDate.toIso8601String()}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('content') && responseData['content'] is List) {
          final List<dynamic> dataJson = responseData['content'];
          setState(() {
            _data = dataJson.cast<Map<String, dynamic>>();
            _isLoading = false;
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
        _fetchData();
      },
      items: _devices.map<DropdownMenuItem<String>>((Map<String, dynamic> device) {
        return DropdownMenuItem<String>(
          value: device['id'].toString(),
          child: Text(device['name'] ?? '未知设备'),
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
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              final item = _data[index];
              return ListTile(
                title: Text('值: ${item['value']}'),
                subtitle: Text('时间: ${DateTime.fromMillisecondsSinceEpoch(item['recordTime']).toString()}'),
              );
            },
          );
  }

  Widget _buildChart() {
    if (_data.isEmpty) {
      return Center(child: Text('暂无数据'));
    }

    List<FlSpot> spots = _data.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        double.parse(entry.value['value'].toString()),
      );
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b),
        maxY: spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}