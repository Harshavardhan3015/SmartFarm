class WeatherData {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final String description;
  final String main;
  final String icon;
  final double humidity;
  final double windSpeed;
  final int windDirection;
  final double pressure;
  final int visibility;
  final double rainChance;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime timestamp;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.main,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.visibility,
    required this.rainChance,
    required this.sunrise,
    required this.sunset,
    required this.timestamp,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];
    final clouds = json['clouds'];
    final sys = json['sys'];

    return WeatherData(
      cityName: json['name'],
      temperature: main['temp'].toDouble(),
      feelsLike: main['feels_like'].toDouble(),
      description: weather['description'],
      main: weather['main'],
      icon: weather['icon'],
      humidity: main['humidity'].toDouble(),
      windSpeed: wind['speed'].toDouble(),
      windDirection: wind['deg']?.toInt() ?? 0,
      pressure: main['pressure'].toDouble(),
      visibility: json['visibility']?.toDouble() ?? 0,
      rainChance: clouds != null ? clouds['all']?.toDouble() ?? 0 : 0,
      sunrise: DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000),
      timestamp: DateTime.now(),
    );
  }

  String get temperatureDisplay => '${temperature.toStringAsFixed(1)}°C';
  String get feelsLikeDisplay => '${feelsLike.toStringAsFixed(1)}°C';
  String get humidityDisplay => '${humidity.toStringAsFixed(0)}%';
  String get windSpeedDisplay => '${windSpeed.toStringAsFixed(1)} m/s';
  String get pressureDisplay => '${pressure.toStringAsFixed(0)} hPa';
  String get visibilityDisplay => '${visibility.toStringAsFixed(1)} km';
  String get rainChanceDisplay => '${(rainChance / 100 * 100).toStringAsFixed(0)}%';

  String get windDirectionDisplay {
    const directions = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'
    ];
    final index = ((windDirection + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  String get timeOfDay {
    final hour = timestamp.hour;
    if (hour >= 5 && hour < 12) return 'Morning';
    if (hour >= 12 && hour < 17) return 'Afternoon';
    if (hour >= 17 && hour < 21) return 'Evening';
    return 'Night';
  }

  String get weatherEmoji {
    switch (main.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
        return '🌫️';
      default:
        return '🌤️';
    }
  }
}

class WeatherForecast {
  final DateTime dateTime;
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String main;
  final String icon;
  final double humidity;
  final double windSpeed;
  final double rainChance;

  WeatherForecast({
    required this.dateTime,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.main,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.rainChance,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];
    final clouds = json['clouds'];

    return WeatherForecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: main['temp'].toDouble(),
      minTemp: main['temp_min'].toDouble(),
      maxTemp: main['temp_max'].toDouble(),
      description: weather['description'],
      main: weather['main'],
      icon: weather['icon'],
      humidity: main['humidity'].toDouble(),
      windSpeed: wind['speed'].toDouble(),
      rainChance: clouds != null ? clouds['all']?.toDouble() ?? 0 : 0,
    );
  }

  String get dayName {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dateTime.weekday - 1];
  }

  String get temperatureRange => '${minTemp.toStringAsFixed(1)}° / ${maxTemp.toStringAsFixed(1)}°';

  String get weatherEmoji {
    switch (main.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
        return '🌫️';
      default:
        return '🌤️';
    }
  }
}
