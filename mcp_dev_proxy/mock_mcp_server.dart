import 'dart:convert';
import 'dart:io';

void main() async {
  await for (final line in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
    final message = jsonDecode(line);
    
    if (message['method'] == 'initialize') {
      final response = {
        'jsonrpc': '2.0',
        'id': message['id'],
        'result': {
          'protocolVersion': '2024-11-05',
          'capabilities': {'tools': <String, dynamic>{}},
          'serverInfo': {'name': 'mock_server', 'version': '1.0.0'}
        }
      };
      print(jsonEncode(response));
    } else if (message['method'] == 'tools/list') {
      final response = {
        'jsonrpc': '2.0',
        'id': message['id'],
        'result': {'tools': <Map<String, dynamic>>[]}
      };
      print(jsonEncode(response));
    }
  }
}
