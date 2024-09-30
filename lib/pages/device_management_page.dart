import 'package:flutter/material.dart';

class DeviceManagementPage extends StatefulWidget {
  const DeviceManagementPage({Key? key}) : super(key: key);

  @override
  _DeviceManagementPageState createState() => _DeviceManagementPageState();
}

class _DeviceManagementPageState extends State<DeviceManagementPage> {
  final List<Map<String, dynamic>> _devices = [
    {'name': '设备1', 'macAddress': '00:11:22:33:44:55', 'status': '在线', 'threshold': 25.0},
    {'name': '设备2', 'macAddress': 'AA:BB:CC:DD:EE:FF', 'status': '离线', 'threshold': 30.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设备管理'),
      ),
      body: Column(
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
                  title: Text(device['name']),
                  subtitle: Text(device['macAddress']),
                  trailing: Text(device['status']),
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
        title: Text(device['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MAC地址: ${device['macAddress']}'),
            Text('状态: ${device['status']}'),
            Text('阈值: ${device['threshold']}'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('添加设备'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: '设备名称'),
              onChanged: (value) {
                // TODO: 更新设备名称
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'MAC地址'),
              onChanged: (value) {
                // TODO: 更新MAC地址
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 实现添加设备逻辑
              Navigator.pop(context);
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

  void _deleteDevice(Map<String, dynamic> device) {
    // TODO: 实现删除设备功能
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
            onPressed: () {
              // TODO: 实现设置阈值逻辑
              final newThreshold = double.tryParse(_thresholdController.text);
              if (newThreshold != null) {
                setState(() {
                  device['threshold'] = newThreshold;
                });
                Navigator.pop(context);
              } else {
                // 显示错误消息
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