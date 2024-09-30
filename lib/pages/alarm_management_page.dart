import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AlarmManagementPage extends StatefulWidget {
  const AlarmManagementPage({Key? key}) : super(key: key);

  @override
  _AlarmManagementPageState createState() => _AlarmManagementPageState();
}

class _AlarmManagementPageState extends State<AlarmManagementPage> {
  List<Map<String, dynamic>> _devices = [];
  String _selectedDevice = '';
  List<Map<String, dynamic>> _alarms = [];
  bool _isLoading = true;

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
              _fetchAlarms();
            } else {
              _isLoading = false;
            }
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load devices: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching devices: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载设备失败: $e')),
      );
    }
  }

  Future<void> _fetchAlarms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/devices/$_selectedDevice/data/above-threshold'));
      if (response.statusCode == 200) {
        final List<dynamic> alarmsJson = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _alarms = alarmsJson.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load alarms: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching alarms: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载报警失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('报警管理'),
      ),
      body: Column(
        children: [
          _buildDeviceSelector(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _alarms.length,
                    itemBuilder: (context, index) {
                      final alarm = _alarms[index];
                      final device = alarm['device'];
                      final recordTime = DateTime.fromMillisecondsSinceEpoch(alarm['recordTime']);
                      final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(recordTime);
                      return ListTile(
                        title: Text('${device['name']} - 值: ${alarm['value']}'),
                        subtitle: Text('时间: $formattedTime'),
                        trailing: Text('阈值: ${device['threshold']}'),
                        onTap: () => _showAlarmDetails(alarm),
                      );
                    },
                  ),
          ),
        ],
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
        _fetchAlarms();
      },
      items: _devices.map<DropdownMenuItem<String>>((Map<String, dynamic> device) {
        return DropdownMenuItem<String>(
          value: device['id'].toString(),
          child: Text(device['name'] ?? '未知设备'),
        );
      }).toList(),
    );
  }

  void _showAlarmDetails(Map<String, dynamic> alarm) {
    final device = alarm['device'];
    final recordTime = DateTime.fromMillisecondsSinceEpoch(alarm['recordTime']);
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(recordTime);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('报警详情'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('设备: ${device['name']}'),
            Text('MAC地址: ${device['macAddress']}'),
            Text('通信通道: ${device['communicationChannel']}'),
            Text('当前值: ${alarm['value']}'),
            Text('阈值: ${device['threshold']}'),
            Text('时间: $formattedTime'),
            Text('设备状态: ${device['isOn'] ? '开启' : '关闭'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
        ],
      ),
    );
  }
}