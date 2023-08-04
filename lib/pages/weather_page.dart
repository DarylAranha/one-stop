import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String weatherData = '';
  bool isLoading = false;

  Future<void> fetchWeather(double latitude, double longitude) async {
    setState(() {
      isLoading = true;
    });

    final apiKey = 'cbaf267cfada9b18d0e0c37a8801d930';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temp = data['main']['temp'];
        setState(() {
          weatherData = 'Temperature: ${(temp - 273.15).toStringAsFixed(2)}°C';
        });
      } else {
        setState(() {
          weatherData = 'Failed to fetch weather data';
        });
      }
    } catch (error) {
      setState(() {
        weatherData = 'Error: $error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Tool'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      Location location = Location();
                      bool _serviceEnabled;
                      PermissionStatus _permissionGranted;
                      LocationData? _locationData;

                      _serviceEnabled = await location.serviceEnabled();
                      if (!_serviceEnabled) {
                        _serviceEnabled = await location.requestService();
                        if (!_serviceEnabled) {
                          return;
                        }
                      }

                      _permissionGranted = await location.hasPermission();
                      if (_permissionGranted == PermissionStatus.denied) {
                        _permissionGranted = await location.requestPermission();
                        if (_permissionGranted != PermissionStatus.granted) {
                          return;
                        }
                      }

                      _locationData = await location.getLocation();
                      if (_locationData != null) {
                        fetchWeather(
                          _locationData.latitude ?? 0.0,
                          _locationData.longitude ?? 0.0,
                        );
                      }
                    },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  SizedBox(width: isLoading ? 8 : 0),
                  Text('Fetch Weather'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              weatherData,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
