import 'package:flutter/material.dart';

import '../services/clipboard_service.dart';
import '../services/config_store.dart';

class AppState with ChangeNotifier {
  String _content = '';
  String _serverIp = '';
  String _serverPort = '5000';
  String _password = '';
  String _clientId = '';
  bool _isConnected = false;
  bool _isLoading = false;
  String? _errorMessage;

  String get content => _content;
  String get serverIp => _serverIp;
  String get serverPort => _serverPort;
  String get password => _password;
  String get clientId => _clientId;
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ConfigStore _configStore = ConfigStore();
  ClipboardService? _clipboardService;

  AppState() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _serverIp = await _configStore.getServerIp();
      _serverPort = await _configStore.getServerPort();
      _password = await _configStore.getPassword();
      _clientId = await _configStore.getClientId();
      _updateClipboardService();
      await fetchContent();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateClipboardService() {
    if (_serverIp.isNotEmpty) {
      _clipboardService = ClipboardService(
        baseUrl: 'http://$_serverIp:$_serverPort',
      );
      _isConnected = true;
    } else {
      _isConnected = false;
    }
    notifyListeners();
  }

  Future<void> fetchContent() async {
    if (_clipboardService == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      _content = await _clipboardService!.fetchContent();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = '连接失败: ${e.toString()}';
      _isConnected = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateContent(String content) async {
    if (_clipboardService == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      await _clipboardService!.updateContent(
        content,
        clientId: _clientId,
        password: _password,
      );
      _content = content;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = '保存失败: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateServerIp(String ip) async {
    _serverIp = ip;
    await _configStore.saveServerIp(ip);
    _updateClipboardService();
    notifyListeners();
  }

  Future<void> updateServerPort(String port) async {
    _serverPort = port;
    await _configStore.saveServerPort(port);
    _updateClipboardService();
    notifyListeners();
  }

  Future<void> updatePassword(String password) async {
    _password = password;
    await _configStore.savePassword(password);
    notifyListeners();
  }
}
