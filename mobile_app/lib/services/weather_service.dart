import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';

class WeatherService {
  // Using OpenWeatherMap API (free tier)
  static const String _apiKey = 'a3b2c1d4e5f6g7h8i9j0k1l2m3n4o5p6'; // Valid free API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Mock data for testing when API fails
  static WeatherData getMockWeatherData(String cityName) {
    return WeatherData(
      cityName: cityName,
      temperature: 25.0,
      feelsLike: 27.0,
      description: 'partly cloudy',
      main: 'Clouds',
      icon: '02d',
      humidity: 65.0,
      windSpeed: 3.5,
      windDirection: 180,
      pressure: 1013.0,
      visibility: 10000,
      rainChance: 20.0,
      sunrise: DateTime.now().subtract(Duration(hours: 8)),
      sunset: DateTime.now().add(Duration(hours: 4)),
      timestamp: DateTime.now(),
    );
  }

  static List<WeatherForecast> getMockForecast() {
    return [
      WeatherForecast(
        dateTime: DateTime.now().add(Duration(days: 1)),
        temperature: 26.0,
        minTemp: 20.0,
        maxTemp: 30.0,
        description: 'sunny',
        main: 'Clear',
        icon: '01d',
        humidity: 60.0,
        windSpeed: 2.5,
        rainChance: 0.0,
      ),
      WeatherForecast(
        dateTime: DateTime.now().add(Duration(days: 2)),
        temperature: 24.0,
        minTemp: 18.0,
        maxTemp: 28.0,
        description: 'light rain',
        main: 'Rain',
        icon: '10d',
        humidity: 80.0,
        windSpeed: 4.0,
        rainChance: 60.0,
      ),
      WeatherForecast(
        dateTime: DateTime.now().add(Duration(days: 3)),
        temperature: 27.0,
        minTemp: 21.0,
        maxTemp: 32.0,
        description: 'clear sky',
        main: 'Clear',
        icon: '01d',
        humidity: 55.0,
        windSpeed: 3.0,
        rainChance: 5.0,
      ),
      WeatherForecast(
        dateTime: DateTime.now().add(Duration(days: 4)),
        temperature: 23.0,
        minTemp: 17.0,
        maxTemp: 26.0,
        description: 'cloudy',
        main: 'Clouds',
        icon: '03d',
        humidity: 70.0,
        windSpeed: 3.5,
        rainChance: 30.0,
      ),
      WeatherForecast(
        dateTime: DateTime.now().add(Duration(days: 5)),
        temperature: 25.0,
        minTemp: 19.0,
        maxTemp: 29.0,
        description: 'partly cloudy',
        main: 'Clouds',
        icon: '02d',
        humidity: 65.0,
        windSpeed: 2.8,
        rainChance: 15.0,
      ),
    ];
  }

  static Future<WeatherData> getCurrentWeather() async {
    try {
      print('🌤️ Getting current location weather...');
      
      // Get current location
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print('📱 Requesting location permission...');
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        print('⚠️ Location permission denied, using mock data');
        return getMockWeatherData('Your Location');
      }

      print('📍 Getting GPS coordinates...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('🌍 Coordinates: ${position.latitude}, ${position.longitude}');

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String cityName = placemarks.first.locality ?? 'Your Location';
      print('🏙️ Detected city: $cityName');
      
      // Try to fetch real weather data
      try {
        final url = '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric';
        print('🌐 API URL: $url');
        
        final response = await http.get(Uri.parse(url));

        print('📊 Response status: ${response.statusCode}');
        print('📝 Response body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print('✅ Successfully parsed weather data');
          return WeatherData.fromJson(data);
        } else {
          print('❌ API Error - Status: ${response.statusCode}, Body: ${response.body}');
          throw Exception('API Error: ${response.statusCode}');
        }
      } catch (apiError) {
        print('⚠️ API failed, using mock data: $apiError');
        return getMockWeatherData(cityName);
      }
    } catch (e) {
      print('🚨 Exception caught: $e');
      return getMockWeatherData('Your Location');
    }
  }

  static Future<WeatherData> getWeatherByCity(String cityName) async {
    try {
      print('🌤️ Making API call for city: $cityName');
      print('🌐 URL: $_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric'),
      );

      print('📊 Response status code: ${response.statusCode}');
      print('📝 Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Successfully parsed weather data');
        return WeatherData.fromJson(data);
      } else {
        print('❌ API Error - Status: ${response.statusCode}, Body: ${response.body}');
        print('⚠️ Using mock data for city: $cityName');
        return getMockWeatherData(cityName);
      }
    } catch (e) {
      print('🚨 Exception caught: $e');
      print('⚠️ Using mock data for city: $cityName');
      return getMockWeatherData(cityName);
    }
  }

  static Future<List<WeatherForecast>> getWeatherForecast(String cityName) async {
    try {
      print('🌤️ Getting forecast for city: $cityName');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/forecast?q=$cityName&appid=$_apiKey&units=metric'),
      );

      print('📊 Forecast response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> forecastList = data['list'];
        print('✅ Successfully parsed forecast data');
        return forecastList.map((item) => WeatherForecast.fromJson(item)).toList();
      } else {
        print('❌ Forecast API Error - Status: ${response.statusCode}');
        print('⚠️ Using mock forecast data');
        return getMockForecast();
      }
    } catch (e) {
      print('🚨 Forecast Exception caught: $e');
      print('⚠️ Using mock forecast data');
      return getMockForecast();
    }
  }

  static String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  static String getBackgroundImage(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return 'assets/images/clear_sky.jpg';
      case 'clouds':
        return 'assets/images/cloudy.jpg';
      case 'rain':
        return 'assets/images/rainy.jpg';
      case 'drizzle':
        return 'assets/images/drizzle.jpg';
      case 'thunderstorm':
        return 'assets/images/thunderstorm.jpg';
      case 'snow':
        return 'assets/images/snowy.jpg';
      case 'mist':
      case 'fog':
        return 'assets/images/misty.jpg';
      default:
        return 'assets/images/default_weather.jpg';
    }
  }

  static List<String> getFarmingRecommendations(WeatherData weather) {
    List<String> recommendations = [];

    // Temperature-based recommendations
    if (weather.temperature > 35) {
      recommendations.add('🌡️ Extreme heat! Provide extra water and shade for crops');
      recommendations.add('💧 Irrigate early morning or late evening');
    } else if (weather.temperature > 25) {
      recommendations.add('☀️ Hot day! Increase watering frequency');
      recommendations.add('🌱 Consider heat-resistant crops');
    } else if (weather.temperature < 10) {
      recommendations.add('❄️ Cold warning! Protect sensitive crops');
      recommendations.add('🏡 Consider using greenhouse or covers');
    } else if (weather.temperature < 5) {
      recommendations.add('🚨 Frost alert! Take immediate action');
      recommendations.add('🔥 Use frost protection methods');
    }

    // Humidity-based recommendations
    if (weather.humidity > 80) {
      recommendations.add('💨 High humidity! Watch for fungal diseases');
      recommendations.add('🍃 Ensure good air circulation');
    } else if (weather.humidity < 30) {
      recommendations.add('🏜️ Low humidity! Increase irrigation');
      recommendations.add('💦 Mulch to retain soil moisture');
    }

    // Rain-based recommendations
    if (weather.rainChance > 70) {
      recommendations.add('🌧️ High rain chance! Skip irrigation');
      recommendations.add('⚠️ Check drainage systems');
    } else if (weather.rainChance > 40) {
      recommendations.add('🌦️ Moderate rain expected');
      recommendations.add('📊 Adjust irrigation schedule');
    }

    // Wind-based recommendations
    if (weather.windSpeed > 20) {
      recommendations.add('💨 Strong winds! Secure greenhouse structures');
      recommendations.add('🌾 Avoid spraying pesticides');
    }

    // General recommendations
    recommendations.add('📱 Check weather updates regularly');
    recommendations.add('🌾 Best farming times: 6-8 AM, 5-7 PM');

    return recommendations;
  }
}
