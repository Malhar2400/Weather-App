import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/AdditionalInfoItem.dart';
import 'package:weather_app/screte.dart';
import 'package:weather_app/weatherForcastItem.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentData() async {
    try {
      String cityName = 'Mumbai';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$APIkey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != "200") {
        throw data['message'];
      }
      return data;
    } catch (e) {
      throw 'An Unexpected Error Occurred';
    }
  }

  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode.png';
  }

  @override
  void initState() {
    super.initState();
    getCurrentData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('images/1.jpg'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Mumbai',
            style: TextStyle(
              fontSize: 48,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/1.jpg'), // replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder(
            future: getCurrentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              final data = snapshot.data;
              final currentWeatherData = data?['list'][0];

              final currentTemp = currentWeatherData?['main']['temp'];
              final currentSky =
                  currentWeatherData?['weather'][0]['description'];
              final currentPressure = currentWeatherData?['main']['pressure'];
              final currentHumidity = currentWeatherData?['main']['humidity'];
              final currentWindSpeed = currentWeatherData?['wind']['speed'];
              final currentFeelslikes =
                  currentWeatherData['main']['feels_like'];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: Colors.black.withOpacity(0.3),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "${kelvinToCelsius(currentTemp).toStringAsFixed(2)} °C",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Image.network(
                                  getIconUrl(
                                      currentWeatherData['weather'][0]['icon']),
                                  width: 78,
                                  height: 78,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$currentSky',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //hourly forcast
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Hourly Forecast',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 15,
                          itemBuilder: (context, index) {
                            final hourlyForecast = data?['list'][index + 1];
                            final hourlySky =
                                data?['list'][index + 1]['weather'][0]['main'];
                            final hourlyTemp = hourlyForecast['main']['temp'];
                            final time =
                                DateTime.parse(hourlyForecast['dt_txt']);
                            return Hourly_Forcast(
                              time: DateFormat.j().format(time),
                              icon: Image.network(
                                getIconUrl(
                                    hourlyForecast['weather'][0]['icon']),
                                width: 32,
                                height: 32,
                              ),
                              temp:
                                  "${kelvinToCelsius(hourlyTemp).toStringAsFixed(2)} °C",
                            );
                          }),
                    ),
                    const SizedBox(height: 20),
                    // Additional info
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      elevation: 6,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AdditionalInfoItem(
                              label: 'Feels Likes ',
                              value:
                                  "${kelvinToCelsius(currentFeelslikes).toStringAsFixed(2)} °C",
                            ),
                            const Divider(
                              height: 25,
                              indent: 16,
                              endIndent: 16,
                            ),
                            AdditionalInfoItem(
                              label: 'Humidity',
                              value: '$currentHumidity %',
                            ),
                            const Divider(
                              height: 25,
                              indent: 16,
                              endIndent: 16,
                            ),
                            AdditionalInfoItem(
                              label: 'Wind speed',
                              value: '$currentWindSpeed Km',
                            ),
                            const Divider(
                              height: 25,
                              indent: 16,
                              endIndent: 16,
                            ),
                            AdditionalInfoItem(
                              label: 'pressure',
                              value: '$currentPressure mbar',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

double kelvinToCelsius(double kelvin) {
  return kelvin - 273.15;
}
