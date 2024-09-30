import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  int _currentPage = 0;
  int _totalPages = 1;

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
      String formattedStartDate = "${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')} 00:00:00";
      String formattedEndDate = "${_endDate.year}-${_endDate.month.toString().padLeft(2, '0')}-${_endDate.day.toString().padLeft(2, '0')} 23:59:59";
      
      String url = 'http://10.0.2.2:8080/api/devices/$_selectedDevice/data?page=$_currentPage&size=10&startTime=$formattedStartDate&endTime=$formattedEndDate';
      print('查询链接: $url');

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('content') && responseData['content'] is List) {
          final List<dynamic> dataJson = responseData['content'];
          setState(() {
            _data = dataJson.cast<Map<String, dynamic>>();
            _totalPages = responseData['totalPages'] ?? 1;
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
        _buildPaginationControls(),
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

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: _currentPage > 0 ? () {
            setState(() {
              _currentPage--;
            });
            _fetchData();
          } : null,
        ),
        Text('${_currentPage + 1} / $_totalPages'),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: _currentPage < _totalPages - 1 ? () {
            setState(() {
              _currentPage++;
            });
            _fetchData();
          } : null,
        ),
      ],
    );
  }
}