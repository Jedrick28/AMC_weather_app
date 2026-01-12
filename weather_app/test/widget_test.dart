import 'package:flutter_test/flutter_test.dart';
// Ensure 'weather_app' matches your pubspec.yaml name
import 'package:weather_app/models/weather.dart';

void main() {
  group('Weather Model Tests', () {
    test('should return a valid Weather model from a realistic Manila JSON response', () {
      // 1. Arrange: Realistic Manila JSON
      final Map<String, dynamic> manilaJson = {
        "weather": [
          {
            "main": "Clouds",
            "description": "broken clouds",
          }
        ],
        "main": {
          "temp": 31.5,
          "humidity": 62
        },
        "wind": {"speed": 4.12},
        "name": "Manila",
      };

      // 2. Act
      final result = Weather.fromJson(manilaJson);

      // 3. Assert
      // Verify these match the EXACT variable names in your lib/models/weather.dart
      expect(result.city, 'Manila');
      expect(result.temperature, 31.5);
      expect(result.description, 'Clouds');
      expect(result.humidity, 62);
      expect(result.windSpeed, 4.12);
    });

    test('should handle integer temperatures and convert to double', () {
      final Map<String, dynamic> jsonWithInt = {
        "weather": [{"main": "Clear"}],
        "main": {"temp": 30, "humidity": 50},
        "wind": {"speed": 5},
        "name": "Manila"
      };

      final result = Weather.fromJson(jsonWithInt);

      expect(result.temperature, 30.0);
      expect(result.windSpeed, 5.0);
    });
  });
}
