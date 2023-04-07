import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Model/images_model.dart';
import '../Model/weather_model.dart';
import '../service/weather_service.dart';
import 'package:intl/intl.dart';

class SevenDayPage extends StatefulWidget {
  const SevenDayPage({super.key});

  @override
  State<SevenDayPage> createState() => _SevenDayPageState();
}

class _SevenDayPageState extends State<SevenDayPage> {
  List<Data>? weatherList = [];
  late Future<WeatherModel?> myWeather;
  final WeatherService _service = WeatherService();
  String selectedCity = 'Ankara';

  @override
  void initState() {
    super.initState();
    myWeather = _service.fetchWeather(selectedCity);
    _service.fetchWeather(selectedCity).then((value) {
      if (value != null && value.data != null) {
        setState(() {
          weatherList = value.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<ImageModel?> imageModel = ImageModel.images;
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: const Color.fromARGB(255, 109, 108, 136),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FutureBuilder<WeatherModel?>(
                        future: myWeather,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String? image;
                            image = imageModel[0]!.imageUrl;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                cityNameAndLottie(snapshot, image),
                                CustomSizedBox()._sizedBox5,
                                tempDegreeDescription(),
                                CustomSizedBox()._sizedBox20,
                                dateTimeAndTemp(),
                                CustomSizedBox()._sizedBox20,
                                sevendayList(),
                                CustomSizedBox()._sizedBox20,
                                weatherDetailsAll(),
                                const SizedBox(height: 50),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('An error occurred while loading data ${snapshot.error}');
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Row cityNameAndLottie(AsyncSnapshot<WeatherModel?> snapshot, String image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            snapshot.data!.cityName.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        lottieAsset(image),
      ],
    );
  }

  Row tempDegreeDescription() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          weatherList != null && weatherList!.isNotEmpty ? weatherList![0].temp!.truncate().toString() : '',
          style: const TextStyle(color: Colors.white, fontSize: 55),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '°C',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomSizedBox()._sizedBox5,
            Row(
              children: [
                Text(
                  weatherList != null && weatherList!.isNotEmpty
                      ? weatherList![0].weather!.description!.toString()
                      : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  lottieAsset(String? image) {
    return Lottie.asset(
      image!,
      height: 100,
      width: 90,
      fit: BoxFit.cover,
    );
  }

  //tarih ve yanındaki max min temp yazan yer
  Row dateTimeAndTemp() {
    if (weatherList == null || weatherList!.isEmpty) {
      return Row(
        children: const [
          Text(
            'No weather data available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            weatherList![0].datetime.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          weatherList != null && weatherList!.isNotEmpty
              ? '${weatherList![0].appMinTemp!.truncate().toString()}°C / ${weatherList![0].appMaxTemp!.truncate().toString()}°C'
              : '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  //AŞAĞIDAKİ WEATHERDETAİLSİN TAMAMI
  Column weatherDetailsAll() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Weather Details',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        CustomSizedBox()._sizedBox5,
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CustomSizedBox()._sizedBox20,
                    const Text(
                      'Felt Temperature',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    CustomSizedBox()._sizedBox5,
                    Text(
                      weatherList != null && weatherList!.isNotEmpty
                          ? '${weatherList![0].temp!.truncate().toString()}°C'
                          : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomSizedBox()._sizedBox20,
                    const Text(
                      'Humudity',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      weatherList != null && weatherList!.isNotEmpty ? '${weatherList![0].rh.toString()}%' : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CustomSizedBox()._sizedBox20,
                    const Text(
                      'East/Southeast Wind',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      weatherList != null && weatherList!.isNotEmpty
                          ? '${weatherList![0].windSpd!.truncate().toString()} km/h'
                          : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomSizedBox()._sizedBox20,
                    const Text(
                      'Type of Wind',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      //İlk harfi büyütmek için
                      weatherList != null && weatherList!.isNotEmpty
                          ? '${weatherList![0].windCdirFull.toString().substring(0, 1).toUpperCase()}${weatherList![0].windCdirFull.toString().substring(1)}'
                          : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CustomSizedBox()._sizedBox20,
                    const Text(
                      'Weather Description',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      weatherList != null && weatherList!.isNotEmpty
                          ? weatherList![0].weather!.description.toString()
                          : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomSizedBox()._sizedBox20,
                    const Text(
                      'Weather Code',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      weatherList != null && weatherList!.isNotEmpty ? weatherList![0].weather!.code.toString() : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  //BU KISIM ŞU TARİHİN ALTINDAKİ OLAN YERİN TAMAMI BİDE BUNLARIN İÇİNİN METHODU VAR ODA SEVENDAYS DİYE TANIMLADIĞIM
  Column sevendayList() {
    String iconUrl = 'https://www.weatherbit.io/static/img/icons/';
    List<Widget> dayWidgets = [];

    for (int i = 0; i < 7; i++) {
      if (weatherList != null && weatherList!.isNotEmpty) {
        String day = (i == 0)
            ? 'Today'
            : (i == 1)
                ? 'Tomorrow'
                : DateFormat('EEEE').format(DateTime.parse(weatherList![i].datetime!));
        String description = weatherList![i].weather!.description.toString();
        String temperature =
            '${weatherList![i].appMinTemp!.truncate().toString()}°C / ${weatherList![i].appMaxTemp!.truncate().toString()}°C';

        dayWidgets.add(CustomSizedBox()._sizedBox5);
        dayWidgets.add(sevenDays(
          Image.network(
            '$iconUrl${weatherList![i].weather!.icon.toString()}.png',
            height: 30,
          ),
          day,
          description,
          temperature,
        ));
      }
    }

    return Column(
      children: [
        divider(),
        CustomSizedBox()._sizedBox20,
        ...dayWidgets,
        CustomSizedBox()._sizedBox20,
        divider(),
      ],
    );
  }

  //BURASI 7 GÜNLÜK VERİNİN İÇİNDEKİ TEXT KISIMLARI BİRDE BUNUN LİSTE OLARAK YANİ TOPLU OLARAK OLANI VAR O DA
  //YANİ BURASI İÇİ DİĞERİ DIŞI
  Widget sevenDays(var lottie, String day, String weat, String dagree) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day,
              style: const TextStyle(color: Colors.white),
            ),
            Row(
              children: [
                lottie,
                const SizedBox(width: 5),
                Text(
                  weat,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
            Text(
              dagree,
              //'${weatherList![0].appMinTemp.toString()}°C / ${weatherList![0].appMaxTemp.toString()}°C',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  /*
  BURADA İSTESEK TODAY'İN YANINDAKİ DESCRİPTİON KISMINDAKİ YAZILARI TEK KELİMEYE DÜŞÜRÜRÜZ
  String descriptionSplit(int rakam) {
    final firstWord = weatherList![rakam].weather!.description.toString().split(' ')[1];
    return firstWord;
  }
  */

  //GRİ OLAN ÇİZGİLER İÇİN
  Divider divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[400],
    );
  }
}

class CustomSizedBox {
  final SizedBox _sizedBox5 = const SizedBox(height: 5);
  final SizedBox _sizedBox20 = const SizedBox(height: 20);
}
