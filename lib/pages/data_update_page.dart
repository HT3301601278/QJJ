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