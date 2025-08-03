import "dart:convert";
import "dart:io";

void main() async {
  await for (final String line
      in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
    final dynamic decoded = jsonDecode(line);

    if (decoded is! Map<String, dynamic>) {
      continue;
    }

    final Map<String, dynamic> message = decoded;

    if (message["method"] == "initialize") {
      final Map<String, dynamic> response = <String, dynamic>{
        "jsonrpc": "2.0",
        "id": message["id"],
        "result": <String, dynamic>{
          "protocolVersion": "2024-11-05",
          "capabilities": <String, dynamic>{
            "tools": <String, dynamic>{},
          },
          "serverInfo": <String, dynamic>{
            "name": "mock_server",
            "version": "1.0.0",
          },
        },
      };
      print(jsonEncode(response));
    } else if (message["method"] == "tools/list") {
      final Map<String, dynamic> response = <String, dynamic>{
        "jsonrpc": "2.0",
        "id": message["id"],
        "result": <String, dynamic>{
          "tools": <Map<String, dynamic>>[],
        },
      };
      print(jsonEncode(response));
    }
  }
}
