import 'package:flutter/material.dart';

class AlarmManagementPage extends StatefulWidget {
  const AlarmManagementPage({Key? key}) : super(key: key);

  @override
  _AlarmManagementPageState createState() => _AlarmManagementPageState();
}

class _AlarmManagementPageState extends State<AlarmManagementPage> {
  final List<Map<String, dynamic>> _alarms = [
    {'id': 1, 'device': '设备1', 'type': '温度过高', 'time': '2023-05-01 10:30:00', 'status': '未处理'},
    {'id': 2, 'device': '设备2', 'type': '水位过低', 'time': '2023-05-02 14:45:00', 'status': '已处理'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('报警管理'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                return ListTile(
                  title: Text('${alarm['device']} - ${alarm['type']}'),
                  subtitle: Text(alarm['time']),
                  trailing: Text(alarm['status']),
                  onTap: () => _showAlarmDetails(alarm),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _showAlarmSettings,
            child: const Text('报警设置'),
          ),
        ],
      ),
    );
  }

  void _showAlarmDetails(Map<String, dynamic> alarm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('报警详情'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('设备: ${alarm['device']}'),
            Text('类型: ${alarm['type']}'),
            Text('时间: ${alarm['time']}'),
            Text('状态: ${alarm['status']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
          TextButton(
            onPressed: () => _handleAlarm(alarm),
            child: Text('处理报警'),
          ),
        ],
      ),
    );
  }

  void _handleAlarm(Map<String, dynamic> alarm) {
    // TODO: 实现报警处理逻辑
    setState(() {
      alarm['status'] = '已处理';
    });
    Navigator.pop(context);
  }

  void _showAlarmSettings() {
    // TODO: 实现报警设置功能
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('报警设置'),
        content: Text('这里可以添加报警阈值设置等功能'),
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