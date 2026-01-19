import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

class WeatherService {
  // Static Constants
  static const String apiKey = '';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Weather> getWeather(String cityName) async {
    try {
      // 1. Properly encode the city name to handle spaces and special characters for the Web
      final encodedCity = Uri.encodeComponent(cityName);
      final String url = '$baseUrl?q=$encodedCity&appid=$apiKey&units=metric';

      final http.Response response = await http.get(
        Uri.parse(url),
        // 2. REMOVED headers: {'Content-Type': 'application/json'}
        // Removing this prevents the CORS 'Preflight' block in browsers.
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Weather.fromJson(data);
      }
      else if (response.statusCode == 404) {
        throw Exception('City not found. Please check the spelling.');
      }
      else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please verify your OpenWeatherMap key.');
      }
      else {
        throw Exception('Failed to load weather. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load weather: $e');
    }
  }
}
