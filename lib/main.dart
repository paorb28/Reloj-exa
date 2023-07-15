import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wear OS App',
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentDate = '';
  String _weatherDescription = '';
  double _temperature = 0.0;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _fetchWeatherData();
  }

  void _updateTime() {
    setState(() {
      _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
    Future.delayed(Duration(seconds: 1), _updateTime);
  }

  Future<void> _fetchWeatherData() async {
    final apiKey =
        'c81d46b4c863da22daed4b1c6b3430a2'; // Reemplaza con tu API Key de OpenWeatherMap
    final city = 'Mexico City'; // Cambia la ciudad según tus necesidades

    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      final weatherDescription = weatherData['weather'][0]['description'];
      final temperature = weatherData['main']['temp'];

      setState(() {
        _weatherDescription = weatherDescription;
        _temperature = temperature;
      });
    } else {
      setState(() {
        _weatherDescription = 'Error al obtener el clima';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.amber],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Cinthia Paola Rodríguez Bahena",
                style: TextStyle(
                  fontSize: 5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                _currentDate,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                DateFormat('h:mm:ss a').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '$_temperature°C',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                _weatherDescription,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
