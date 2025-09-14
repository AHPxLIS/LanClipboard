import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../models/app_state.dart';
import '../widgets/connection_indicator.dart';
import 'settings_screen.dart'; 

class ClipboardScreen extends StatefulWidget {
  const ClipboardScreen({super.key});

  @override
  State<ClipboardScreen> createState() => _ClipboardScreenState();
}

class _ClipboardScreenState extends State<ClipboardScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    if (_textController.text != appState.content) {
      _textController.text = appState.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('剪贴板共享'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const ConnectionIndicator(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (appState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  appState.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '共享文本',
                  hintText: '输入要共享的文本',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('拉取'),
                    onPressed: () async {
                      EasyLoading.show(status: '拉取中...');
                      await appState.fetchContent();
                      EasyLoading.dismiss();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.upload),
                    label: const Text('保存'),
                    onPressed: () async {
                      EasyLoading.show(status: '保存中...');
                      await appState.updateContent(_textController.text);
                      EasyLoading.dismiss();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
