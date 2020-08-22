import 'package:http/http.dart' as http;
import 'dart:convert';

class Rest {
  Rest();

  Future postTo(
    var url,
    var headers,
    Map body,
  ) async {
    String bodyString = json.encode(body);
    http.Response response =
        await http.post(url, headers: headers, body: bodyString);
    if (response.statusCode != 200) {
      var json = jsonDecode(response.body);
      print('rest.dart: postTo: $url: Non 200 response recevied: $json');
      return;
    }
    print('rest.dart: postTo: $url successful: response: $response');
    String responseBody = response.body;
    return json.decode(responseBody);
  }

  Future<Map<String, dynamic>> getFrom(
      String url, Map<String, String> headers) async {
    http.Response response = await http.get(url, headers: headers);
    int code = response.statusCode;
    String body = response.body;
    if (code != 200) {
      print('rest.dart: getFrom: $url: Non 200 response: $code: body: $body');
      return {};
    }
    print('rest.dart: getFrom: $url: successful.');
    return json.decode(body);
  }

  Future<bool> delete(String url, Map<String, String> headers) async {
    http.Response response = await http.delete(url, headers: headers);
    int code = response.statusCode;
    if (code != 200) {
      print('rest.dart: delete: $url: Non 200 response: $code');
      return false;
    }
    return true;
  }
}
