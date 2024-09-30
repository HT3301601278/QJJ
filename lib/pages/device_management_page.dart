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
            _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设备管理'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '搜索设备',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // TODO: 实现设备搜索功能
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      return ListTile(
                        title: Text(device['name'] ?? '未知设备'),
                        subtitle: Text(device['macAddress'] ?? '未知MAC地址'),
                        trailing: Text(device['isOn'] ? '在线' : '离线'),
                        onTap: () => _showDeviceDetails(device),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDevice,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeviceDetails(Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(device['name'] ?? '未知设备'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MAC地址: ${device['macAddress'] ?? '未知'}'),
            Text('通信通道: ${device['communicationChannel'] ?? '未知'}'),
            Text('阈值: ${device['threshold']?.toString() ?? '未设置'}'),
            Text('状态: ${device['isOn'] == true ? '在线' : '离线'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
          TextButton(
            onPressed: () => _editDevice(device),
            child: Text('编辑'),
          ),
          TextButton(
            onPressed: () => _deleteDevice(device),
            child: Text('删除'),
          ),
          TextButton(
            onPressed: () => _setThreshold(device),
            child: Text('设置阈值'),
          ),
        ],
      ),
    );
  }

  void _addDevice() {
    final _nameController = TextEditingController();
    final _macAddressController = TextEditingController();
    final _communicationChannelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('添加设备'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '设备名称'),
            ),
            TextField(
              controller: _macAddressController,
              decoration: InputDecoration(labelText: 'MAC地址'),
            ),
            TextField(
              controller: _communicationChannelController,
              decoration: InputDecoration(labelText: '通信通道'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final response = await http.post(
                Uri.parse('http://10.0.2.2:8080/api/devices'),
                headers: {'Content-Type': 'application/json'},
                body: json.encode({
                  'name': _nameController.text,
                  'macAddress': _macAddressController.text,
                  'communicationChannel': _communicationChannelController.text,
                }),
              );

              if (response.statusCode == 200) {
                Navigator.pop(context);
                _fetchDevices();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('添加设备失败')),
                );
              }
            },
            child: Text('添加'),
          ),
        ],
      ),
    );
  }

  void _editDevice(Map<String, dynamic> device) {
    // TODO: 实现编辑设备功能
  }

  void _deleteDevice(Map<String, dynamic> device) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:8080/api/devices/${device['id']}'));

    if (response.statusCode == 200) {
      _fetchDevices();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('删除设备失败')),
      );
    }
  }

  void _setThreshold(Map<String, dynamic> device) {
    final _thresholdController = TextEditingController(text: device['threshold'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('设置阈值'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('设备: ${device['name']}'),
            TextField(
              controller: _thresholdController,
              decoration: InputDecoration(labelText: '阈值'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final newThreshold = double.tryParse(_thresholdController.text);
              if (newThreshold != null) {
                final response = await http.put(
                  Uri.parse('http://10.0.2.2:8080/api/devices/${device['id']}/threshold?threshold=$newThreshold'),
                );

                if (response.statusCode == 200) {
                  Navigator.pop(context);
                  _fetchDevices();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('设置阈值失败')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('请输入有效的数字')),
                );
              }
            },
            child: Text('保存'),
          ),
        ],
      ),
    );
  }
}