import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Hasan Alani / B1905.090005
// Weather application Homework

void main() => runApp(const MyWeatherApp());

class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 6, color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 4, color: Colors.white54),
          ),
        ),
      ),
      home: const IauWeatherPage(),
    );
  }
}

class IauWeatherPage extends StatefulWidget {
  const IauWeatherPage({super.key});

  @override
  IauWeatherPageState createState() => IauWeatherPageState();
}

class IauWeatherPageState extends State<IauWeatherPage> {
  final cityButtonController = TextEditingController();
  final String _apiKey = "FQ6SSUYXWMPFSRFMWDJ5ND6JU";
  String weatherDegree = "";
  String weatherDescription = "";
  String cityName = "";
  var apiResponse;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/app_background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white54,
          title: const Text('IAU Weather'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white), //<-- SEE HERE
                controller: cityButtonController,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: "Enter city name",
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () async {
                  // Make the API call to get the weather data
                  cityName = cityButtonController.text.toLowerCase();
                  if (cityName.isNotEmpty) {
                    try {
                      apiResponse = await http.get(
                        Uri.parse(
                          'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$cityName?unitGroup=metric&include=current&key=$_apiKey&contentType=json',
                        ),
                      );
                      var weatherData = jsonDecode(apiResponse.body);
                      setState(() {
                        weatherDegree = "${weatherData['days'][0]['temp']} C";
                        weatherDescription =
                            "${weatherData['days'][0]['conditions']}, ${weatherData['days'][0]['description']} ";
                      });
                    } on Exception catch (e) {
                      e.toString();
                    }
                  } else {
                    setState(() {
                      weatherDegree = "Please Enter City Name!";
                      weatherDescription = "";
                    });
                  }
                },
                child: const Text('Check Weather'),
              ),
              const SizedBox(height: 18),
              Text(
                "$weatherDegree\n${cityName.toUpperCase()}\n$weatherDescription",
                style: const TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
