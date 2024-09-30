# 水温水位在线监测系统

## 项目简介

这是一个基于 Flutter 开发的水温水位在线监测系统移动应用。该系统允许用户管理设备、查看实时和历史数据、生成报表以及处理报警信息。

## 项目结构

```
lib/
├── main.dart
└── pages/
    ├── login_page.dart
    ├── register_page.dart
    ├── dashboard_page.dart
    ├── device_management_page.dart
    ├── data_management_page.dart
    ├── data_update_page.dart
    ├── alarm_management_page.dart
    └── report_generation_page.dart
```

## 文件说明

### main.dart

这是应用的入口文件，负责初始化应用并设置主题。

主要功能：
- 设置应用标题
- 配置应用主题
- 设置初始路由为登录页面


```1:23:lib/main.dart
import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '水温水位在线监测系统',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}
```


### pages/login_page.dart

登录页面，允许用户输入用户名和密码进行身份验证。

主要功能：
- 用户登录表单
- 登录验证逻辑
- 导航到注册页面


```1:174:lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'register_page.dart';
import 'dashboard_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '欢迎回来',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: '用户名',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入用户名';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: '密码',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
```


### pages/register_page.dart

注册页面，允许新用户创建账户。

主要功能：
- 用户注册表单
- 注册验证逻辑

### pages/dashboard_page.dart

仪表盘页面，显示系统概览和快速操作。

主要功能：
- 显示设备统计信息
- 实时数据图表
- 快速操作按钮


```1:84:lib/pages/dashboard_page.dart
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
```


### pages/device_management_page.dart

设备管理页面，允许用户添加、编辑和删除设备。

主要功能：
- 设备列表显示
- 添加新设备
- 编辑设备信息
- 删除设备
- 设置设备阈值


```1:300:lib/pages/device_management_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeviceManagementPage extends StatefulWidget {
  const DeviceManagementPage({Key? key}) : super(key: key);

  @override
  _DeviceManagementPageState createState() => _DeviceManagementPageState();
}


class _DeviceManagementPageState extends State<DeviceManagementPage> {
  List<Map<String, dynamic>> _devices = [];
  List<Map<String, dynamic>> _filteredDevices = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设备管理'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchDevices,
          ),
        ],
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: _buildDeviceGrid(),
              ),
            ],
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDevice,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: '搜索设备',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: _filterDevices,
      ),
    );
  }

  Widget _buildDeviceGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0, // 改为 1.0 或更小的值,如 0.8
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _filteredDevices.length,
      itemBuilder: (context, index) {
        final device = _filteredDevices[index];
        return _buildDeviceCard(device);
      },
```


### pages/data_management_page.dart

数据管理页面，用于查看和分析设备数据。

主要功能：
- 实时数据显示
- 历史数据查询
- 数据可视化


```1:303:lib/pages/data_management_page.dart
...

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
              elevation: 4,
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
          SizedBox(height: 16),
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
                ),
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
    return Padding(
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
              return DropdownMenuItem<String>(
  Widget _buildChartTypeSelector() {
    // TODO: 实现图表类型选择器
    return Container();
  }
            isExpanded: true,
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
        Expanded(
  Widget _buildChart() {
    if (_data.isEmpty) {
      return Center(child: Text('暂无数据'));
    }
  }
    List<FlSpot> spots = _data.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        double.parse(entry.value['value'].toString()),
      );
    }).toList();
          final picked = await showDatePicker(
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
      ),
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
```


### pages/data_update_page.dart

数据更新页面，允许用户手动更新设备数据。

主要功能：
- 手动数据输入表单
- 数据更新日志


```1:114:lib/pages/data_update_page.dart
import 'package:flutter/material.dart';

class DataUpdatePage extends StatefulWidget {
  const DataUpdatePage({Key? key}) : super(key: key);

  @override
  _DataUpdatePageState createState() => _DataUpdatePageState();
}

class _DataUpdatePageState extends State<DataUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _macAddressController = TextEditingController();
  final _channelController = TextEditingController();
  final _durationController = TextEditingController();
  String _updateLog = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('手动数据更新'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _macAddressController,
                decoration: const InputDecoration(
                  labelText: 'MAC地址',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入MAC地址';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _channelController,
                decoration: const InputDecoration(
                  labelText: '通信通道',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入通信通道';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: '数据持续时间（小时）',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入数据持续时间';
                  }
                  if (int.tryParse(value) == null) {
                    return '请输入有效的数字';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateData,
                child: const Text('更新数据'),
              ),
              const SizedBox(height: 24),
              const Text('更新日志：'),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_updateLog),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateData() {
    if (_formKey.currentState!.validate()) {
      // TODO: 实现实际的数据更新逻辑
      setState(() {
        _updateLog += '开始更新数据：\n';
        _updateLog += 'MAC地址: ${_macAddressController.text}\n';
        _updateLog += '通信通道: ${_channelController.text}\n';
        _updateLog += '数据持续时间: ${_durationController.text}小时\n';
        _updateLog += '更新完成\n\n';
      });
    }
  }

  @override
  void dispose() {
    _macAddressController.dispose();
    _channelController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
```


### pages/alarm_management_page.dart

报警管理页面，用于查看和处理设备报警信息。

主要功能：
- 报警列表显示
- 报警详情查看
- 报警处理

### pages/report_generation_page.dart

报表生成页面，允许用户生成自定义报表。

主要功能：
- 报表参数设置
- 报表生成
- 报表导出


```1:145:lib/pages/report_generation_page.dart
import 'package:flutter/material.dart';

class ReportGenerationPage extends StatefulWidget {
  const ReportGenerationPage({Key? key}) : super(key: key);

  @override
  _ReportGenerationPageState createState() => _ReportGenerationPageState();
}

class _ReportGenerationPageState extends State<ReportGenerationPage> {
  final List<String> _devices = ['设备1', '设备2', '设备3'];
  String _selectedDevice = '设备1';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  String _reportType = '日报';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('报表生成'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeviceSelector(),
            const SizedBox(height: 16),
            _buildDateRangePicker(),
            const SizedBox(height: 16),
            _buildReportTypeSelector(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _generateReport,
              child: const Text('生成报表'),
            ),
          ],
        ),
      ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _buildReportTypeSelector() {
    return DropdownButton<String>(
      value: _reportType,
      onChanged: (String? newValue) {
        setState(() {
          _reportType = newValue!;
        });
      },
      items: <String>['日报', '周报', '月报']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _generateReport() {
    // TODO: 实现报表生成逻辑
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('报表生成'),
        content: Text('报表生成成功！\n设备: $_selectedDevice\n开始日期: ${_startDate.toString().substring(0, 10)}\n结束日期: ${_endDate.toString().substring(0, 10)}\n报表类型: $_reportType'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 实现报表导出逻辑
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('报表已导出')),
              );
            },
            child: Text('导出'),
          ),
        ],
      ),
    );
  }
}
```


## 如何运行项目

1. 确保已安装 Flutter 开发环境。
2. 克隆项目到本地。
3. 在项目根目录运行 `flutter pub get` 安装依赖。
4. 连接模拟器或真机设备。
5. 运行 `flutter run` 启动应用。

## 学习建议

1. 从 `main.dart` 开始，了解应用的整体结构和主题设置。
2. 研究 `login_page.dart` 和 `register_page.dart`，学习用户认证的实现方式。
3. 深入研究 `dashboard_page.dart`，了解如何构建复杂的 UI 布局和数据展示。
4. 学习 `device_management_page.dart` 中的 CRUD 操作实现。
5. 研究 `data_management_page.dart` 中的数据查询和可视化技术。
6. 了解 `data_update_page.dart` 中的表单处理和数据更新逻辑。
7. 学习 `alarm_management_page.dart` 中的列表展示和状态管理。
8. 研究 `report_generation_page.dart` 中的自定义报表生成逻辑。

通过逐步学习这些文件，你将能够全面了解这个水温水位在线监测系统的实现，并掌握 Flutter 应用开发的各种技巧和最佳实践。