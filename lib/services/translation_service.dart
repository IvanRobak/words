import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslationService {
  final String _subscriptionKey;
  final String _endpoint;
  final String _location;

  TranslationService(this._subscriptionKey, this._endpoint, this._location);

  Future<String> translate(String text, String from, String to) async {
    final url =
        Uri.parse('$_endpoint/translate?api-version=3.0&from=$from&to=$to');

    final response = await http.post(
      url,
      headers: {
        'Ocp-Apim-Subscription-Key': _subscriptionKey,
        'Ocp-Apim-Subscription-Region': _location,
        'Content-Type': 'application/json',
      },
      body: jsonEncode([
        {'Text': text}
      ]),
    );

    if (response.statusCode == 200) {
      final translations = jsonDecode(response.body);
      return translations[0]['translations'][0]['text'];
    } else {
      throw Exception('Failed to translate text');
    }
  }
}
