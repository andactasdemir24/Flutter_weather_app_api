import 'package:flutter_weather_app/Model/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  /*
  final String url =
      'https://api.weatherbit.io/v2.0/forecast/daily?city=Raleigh,NC&key=5cea02af6cd6498d9524cedb8ab23b4c';

  Future<WeatherModel?> fetchWeather() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonBody = WeatherModel.fromJson(jsonDecode(response.body));
      return jsonBody;
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
    }
    return null;
  }
  */
  //YUKARIDAKİ KODDA APİNİN BANA SAĞLADIĞI ŞEHRİ ALIYORUM BU İŞİN BASE KODU YUKARIDAKİ
  //BURADA İSE KULLANICIYA ŞEHRİ SEÇTİRDİM O YUZDEN BÖYLE YAPTIM
  Future<WeatherModel?> fetchWeather(String city) async {
    String url2 = 'https://api.weatherbit.io/v2.0/forecast/daily?city=$city&key=5de7cd9e37934929808817a7fb5ababb';
    var response = await http.get(Uri.parse(url2));
    if (response.statusCode == 200) {
      var jsonBody = WeatherModel.fromJson(jsonDecode(response.body));
      return jsonBody;
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
    }
    return null;
  }
}
