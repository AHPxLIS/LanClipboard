import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController ipController;
  late final TextEditingController portController;
  late final TextEditingController passwordController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();   // 只在 initState 读一次
    ipController = TextEditingController(text: appState.serverIp);
    portController = TextEditingController(text: appState.serverPort);
    passwordController = TextEditingController(text: appState.password);
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();   // 仅用于刷新 UI
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(controller: ipController, decoration: const InputDecoration(labelText: '服务端IP')),
              const SizedBox(height: 16),
              TextFormField(controller: portController, decoration: const InputDecoration(labelText: '服务端端口')),
              const SizedBox(height: 16),
              TextFormField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: '密码')),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  await appState.updateServerIp(ipController.text);
                  await appState.updateServerPort(portController.text);
                  await appState.updatePassword(passwordController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('设置已保存，正在测试连接...')),
                  );
                  await appState.fetchContent();
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('保存设置'),
              ),
              const SizedBox(height: 16),
              Text('客户端ID: ${appState.clientId}', style: const TextStyle(color: Colors.grey)),
              InkWell(
                onTap: () => launchUrl(Uri.parse('https://github.com/ahpxlis')),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(text: '作者：', style: TextStyle(color: Colors.grey)),
                      TextSpan(text: 'Ahpxlis', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}