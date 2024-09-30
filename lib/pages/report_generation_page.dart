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