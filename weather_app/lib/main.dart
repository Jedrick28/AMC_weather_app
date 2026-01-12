import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pink Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  Weather? _weather;
  bool _isLoading = false;

  // 1. Create a controller for the search bar
  final TextEditingController _searchController = TextEditingController();

  // 2. Modified fetchWeather to accept a city name
  Future<void> _fetchWeather([String cityName = "Manila"]) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await WeatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: City not found or $e"),
            backgroundColor: Colors.pinkAccent,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  // 3. Clean up controller when widget is destroyed
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text("🌈 Weather App 🌈", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView( // Added scroll view to prevent overflow when keyboard appears
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 4. Added Search Bar Widget
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Enter City Name...",
                  hintStyle: TextStyle(color: Colors.pink[200]),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _fetchWeather(value);
                  }
                },
              ),

              const SizedBox(height: 30),

              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.pink))
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.pink, size: 40),
                  Text(
                    _weather?.city ?? "Not Found",
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${_weather?.temperature.round() ?? 0}°C",
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    _weather?.description.toUpperCase() ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.pink[300],
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard("Humidity", "${_weather?.humidity}%", Icons.water_drop),
                      _buildStatCard("Wind", "${_weather?.windSpeed} m/s", Icons.air),
                    ],
                  ),

                  const SizedBox(height: 50),

                  ElevatedButton.icon(
                    onPressed: () => _fetchWeather(_searchController.text.isEmpty ? "Manila" : _searchController.text),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh Weather"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.pink[200]),
        Text(title, style: TextStyle(color: Colors.pink[200], fontSize: 14)),
        Text(value, style: const TextStyle(color: Colors.pink, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
