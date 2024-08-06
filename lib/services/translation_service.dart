import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  final String apiKey;
  final String endpoint;
  final String location;

  TranslationService(this.apiKey, this.endpoint, this.location);

  Future<String> translate(String text, String from, String to) async {
    final url = Uri.parse('$endpoint/translate?api-version=3.0&from=$from&to=$to');
    final headers = {
      'Ocp-Apim-Subscription-Key': apiKey,
      'Ocp-Apim-Subscription-Region': location,
      'Content-Type': 'application/json',
    };
    final body = jsonEncode([
      {'Text': text}
    ]);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final translation = data[0]['translations'][0]['text'];
      return translation.toLowerCase();
    } else {
      throw Exception('Failed to translate text');
    }
  }
}
