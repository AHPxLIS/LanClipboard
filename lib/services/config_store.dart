import 'package:shared_preferences/shared_preferences.dart';

class ConfigStore {
  static const String _serverIpKey = 'server_ip';
  static const String _serverPortKey = 'server_port';
  static const String _passwordKey = 'password';
  static const String _clientIdKey = 'client_id';

  Future<void> saveServerIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serverIpKey, ip);
  }

  Future<String> getServerIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_serverIpKey) ?? '';
  }

  Future<void> saveServerPort(String port) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serverPortKey, port);
  }

  Future<String> getServerPort() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_serverPortKey) ?? '5000';
  }

  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passwordKey, password);
  }

  Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey) ?? '';
  }

  Future<String> getClientId() async {
    final prefs = await SharedPreferences.getInstance();
    String? clientId = prefs.getString(_clientIdKey);

    if (clientId == null) {
      // 生成唯一的客户端ID
      clientId = 'client_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(_clientIdKey, clientId);
    }

    return clientId;
  }
}
