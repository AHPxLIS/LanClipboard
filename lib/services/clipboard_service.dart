import 'dart:convert';
import 'package:http/http.dart' as http;

class ClipboardService {
  final String baseUrl;

  ClipboardService({required this.baseUrl});

  Future<String> fetchContent() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clipboard')).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'] ?? '';
      } else {
        throw Exception('服务器错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('连接服务器失败: $e');
    }
  }

  Future<void> updateContent(
    String content, {
    String? clientId,
    String? password,
  }) async {
    try {
      final headers = <String, String>{'Content-Type': 'application/json'};

      if (password != null && password.isNotEmpty) {
        headers['X-Auth-Password'] = password;
      }

      final body = jsonEncode({
        'content': content,
        if (clientId != null) 'client_id': clientId,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/clipboard'),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        throw Exception('服务器错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('保存失败: $e');
    }
  }
}
