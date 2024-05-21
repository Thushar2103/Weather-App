import 'dart:convert';
import 'package:weather/models/weather.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String apiKey = dotenv.env['openweather'].toString();
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Weather> getWeather(String city) async {
    final response =
        await http.get(Uri.parse('$baseUrl?q=$city&appid=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Weather(
        city: data['name'],
        temperature: data['main']['temp'].toDouble(),
        description: data['weather'][0]['description'],
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
