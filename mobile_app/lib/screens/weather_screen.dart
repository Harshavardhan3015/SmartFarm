import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherData? _currentWeather;
  List<WeatherForecast>? _forecast;
  bool _isLoading = false;
  bool _isLoadingForecast = false;
  String _searchCity = '';
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentLocationWeather();
  }

  Future<void> _loadCurrentLocationWeather() async {
    setState(() => _isLoading = true);
    try {
      final weather = await WeatherService.getCurrentWeather();
      setState(() {
        _currentWeather = weather;
        _isLoading = false;
      });
      _loadForecast(weather.cityName);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to get weather: $e');
    }
  }

  Future<void> _loadWeatherByCity(String cityName) async {
    if (cityName.isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      final weather = await WeatherService.getWeatherByCity(cityName);
      setState(() {
        _currentWeather = weather;
        _isLoading = false;
        _searchCity = cityName;
      });
      _loadForecast(cityName);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to get weather: $e');
    }
  }

  Future<void> _loadForecast(String cityName) async {
    setState(() => _isLoadingForecast = true);
    try {
      final forecast = await WeatherService.getWeatherForecast(cityName);
      setState(() {
        _forecast = forecast.take(5).toList(); // Next 5 days
        _isLoadingForecast = false;
      });
    } catch (e) {
      setState(() => _isLoadingForecast = false);
      _showErrorSnackBar('Failed to get forecast: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            if (_isLoading) ...[
              const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
              const SizedBox(height: 200),
            ] else if (_currentWeather != null) ...[
              _buildCurrentWeatherCard(),
              const SizedBox(height: 20),
              _buildFarmingRecommendations(),
              const SizedBox(height: 20),
              _buildForecastSection(),
            ] else ...[
              _buildEmptyState(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: 'Enter city name...',
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (value) => _loadWeatherByCity(value.trim()),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _loadWeatherByCity(_cityController.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherCard() {
    if (_currentWeather == null) return const SizedBox();

    return Card(
      elevation: 8,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade600,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentWeather!.cityName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _currentWeather!.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _currentWeather!.weatherEmoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherDetail(
                    'Temperature',
                    _currentWeather!.temperatureDisplay,
                    Icons.thermostat,
                  ),
                  _buildWeatherDetail(
                    'Feels Like',
                    _currentWeather!.feelsLikeDisplay,
                    Icons.device_thermostat,
                  ),
                  _buildWeatherDetail(
                    'Humidity',
                    _currentWeather!.humidityDisplay,
                    Icons.water_drop,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherDetail(
                    'Wind',
                    '${_currentWeather!.windSpeedDisplay} ${_currentWeather!.windDirectionDisplay}',
                    Icons.air,
                  ),
                  _buildWeatherDetail(
                    'Pressure',
                    _currentWeather!.pressureDisplay,
                    Icons.compress,
                  ),
                  _buildWeatherDetail(
                    'Rain Chance',
                    _currentWeather!.rainChanceDisplay,
                    Icons.grain,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFarmingRecommendations() {
    if (_currentWeather == null) return const SizedBox();

    final recommendations = WeatherService.getFarmingRecommendations(_currentWeather!);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.agriculture, color: Colors.green, size: 24),
                SizedBox(width: 10),
                Text(
                  'Farming Recommendations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...recommendations.map((recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastSection() {
    if (_isLoadingForecast) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    if (_forecast == null || _forecast!.isEmpty) {
      return const SizedBox();
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.green, size: 24),
                SizedBox(width: 10),
                Text(
                  '5-Day Forecast',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _forecast!.length,
                itemBuilder: (context, index) {
                  final day = _forecast![index];
                  return _buildForecastCard(day);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastCard(WeatherForecast forecast) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              forecast.dayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              forecast.weatherEmoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              forecast.temperatureRange,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No Weather Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Search for a city or enable location access',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadCurrentLocationWeather,
              icon: const Icon(Icons.my_location),
              label: const Text('Use My Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
