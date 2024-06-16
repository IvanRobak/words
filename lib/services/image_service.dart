import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageService {
  static const String apiKey = 'y8t05W8nhYlWmxrXVtL6H4YP8z1WswOC9ypIMLOijYg';
  static const String endpoint = 'https://api.unsplash.com/photos/random';

  Future<String> fetchImageUrl(String query) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cacheKey = 'image_$query';

    // Перевірка кешу
    if (prefs.containsKey(cacheKey)) {
      return prefs.getString(cacheKey)!;
    }

    // Запит до API
    final response = await http.get(
      Uri.parse('$endpoint?query=$query&client_id=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final imageUrl = data['urls']['small'];

      // Збереження результату в кеш
      await prefs.setString(cacheKey, imageUrl);
      return imageUrl;
    } else {
      throw Exception('Failed to load image');
    }
  }
}
