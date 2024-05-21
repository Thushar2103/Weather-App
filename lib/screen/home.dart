// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/service/weather_service.dart';

class WeatherApp extends StatefulWidget {
  late WeatherService weatherService;

  WeatherApp({required this.weatherService});

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late Future<Weather> weather;
  final TextEditingController _cityController = TextEditingController();

  final Map<String, String> weatherImageMap = {
    'clear sky': 'assets/sun.png',
    'few clouds': 'assets/cloud.png',
    'scattered clouds': 'assets/cloud.png',
    'broken clouds': 'assets/cloud.png',
    'shower rain': 'assets/cloud-lightning.png',
    'rain': 'assets/rain.png',
    'thunderstorm': 'assets/storm.png',
    'snow': 'assets/snow.png',
    'mist': 'assets/mist.png',
    // Add more mappings as needed
  };

  @override
  void initState() {
    super.initState();
    // Initial city for demonstration purposes
    weather = widget.weatherService.getWeather('london');
  }

  Future<void> _searchWeather() async {
    String cityName = _cityController.text.trim();
    if (cityName.isNotEmpty) {
      setState(() {
        weather = widget.weatherService.getWeather(cityName);
      });
    }
  }

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) / 1.8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20.0), // Set the border radius here
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                                0.2), // Adjust the opacity as needed
                            borderRadius: BorderRadius.circular(
                                20.0), // Match the border radius
                            border: Border.all(
                              color:
                                  Colors.white.withOpacity(0.3), // Border color
                              width: 1.5, // Border width
                            ),
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              width: double.maxFinite,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: TextField(
                                    controller: _cityController,
                                    decoration: InputDecoration(
                                      labelText: 'Enter City',
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.search),
                                        onPressed: _searchWeather,
                                      ),
                                    ),
                                  ))))))),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Remove duplicate TextField widget
              const SizedBox(height: 20),
              FutureBuilder<Weather>(
                future: weather,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String description =
                        snapshot.data!.description.toLowerCase();

                    String imagePath = weatherImageMap.containsKey(description)
                        ? weatherImageMap[description]!
                        : 'assets/cloud.png';

                    return Center(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20.0), // Set the border radius here
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          height: 380,
                          width: 380,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                                0.2), // Adjust the opacity as needed
                            borderRadius: BorderRadius.circular(
                                20.0), // Match the border radius
                            border: Border.all(
                              color:
                                  Colors.white.withOpacity(0.3), // Border color
                              width: 1.5, // Border width
                            ),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(imagePath),
                                            fit: BoxFit.cover)),
                                  )
                                  // Image.asset(

                                  //   width: 100,
                                  //   height: 100,
                                  // ),
                                  ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      8.0), // Add padding to the text
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'City: ${snapshot.data!.city}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      ),
                                      Text(
                                        'Temperature: ${snapshot.data?.temperature.toStringAsFixed(1)}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Description: ${snapshot.data!.description}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Enter City Name'));
                  }

                  return Center(child: const CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
