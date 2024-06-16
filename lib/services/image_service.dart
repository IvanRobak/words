import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageService {
  static const String apiKey = 'y8t05W8nhYlWmxrXVtL6H4YP8z1WswOC9ypIMLOijYg';
  static const String endpoint = 'https://api.unsplash.com/photos/random';

  Future<String> fetchImageUrl(String query) async {
    final response = await http.get(
      Uri.parse('$endpoint?query=$query&client_id=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['urls']['small'];
    } else {
      throw Exception('Failed to load image');
    }
  }
}
