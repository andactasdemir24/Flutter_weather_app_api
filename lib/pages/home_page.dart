import 'package:flutter/material.dart';
import 'package:flutter_weather_app/Model/city_model.dart';
import 'package:flutter_weather_app/pages/seven_day_page.dart';
import 'package:lottie/lottie.dart';
import '../Model/weather_model.dart';
import '../service/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Data> weatherList = []; //BURDA İÇTEKİ DATALARI ALMAK İÇİN BOŞ LİSTEYE ATTIM
  late Future<WeatherModel?> myWeather; //BURADA EN BAŞTAKİ VERİLERİ ALDIM
  final WeatherService _service = WeatherService(); //Servisi çektim api
  //Sayfayı yenilemede kullanmak için key oluşturdum
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  //cityModeli home page de oluştrdum
  final CityModel cityModel = CityModel();
  //uygulama açılınca gösterilen şehir
  String selectedCity = 'Ankara';

  //Kontrolleri yap
  @override
  void initState() {
    super.initState();
    //selectedCity yazmamın sebebi servisteki gelen apide city değerini kendim girmek istediğim için bir şehir girmem lazım
    //bende bu şehri ilk başta ankara olarak tanımladım alttaki de aynı şekil
    myWeather = _service.fetchWeather(selectedCity.toLowerCase());
    _service.fetchWeather(selectedCity.toLowerCase()).then((value) {
      if (value != null && value.data != null) {
        setState(() {
          weatherList = value.data!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.amber,
          onPressed: () {
            // Global keyden gelen anlık veriyi gösteriyor
            _refreshIndicatorKey.currentState?.show();
          },
          label: const Text('Change City'),
          icon: const Icon(Icons.refresh),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 109, 108, 136),
      //FloatAction butona basınca sayfa yenilemesi yaptım
      //refreshIndicator o işe yarıyor
      body: RefreshIndicator(
        key: _refreshIndicatorKey, //en yukarıda key tanımlı
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 2.0,
        //BU FONKSİYON İÇİNDE VERİLER DEĞİŞİYOR
        onRefresh: onRefresh,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 30.0,
          ),
          child: Stack(
            children: [
              SafeArea(
                  top: true,
                  child: Column(
                    children: [
                      CustomSizedBox()._sizedBox20,
                      FutureBuilder<WeatherModel?>(
                        future: myWeather,
                        builder: (context, snapshot) {
                          if (weatherList.isNotEmpty) {
                            if (snapshot.hasData) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  selectCityButton(context),
                                  cityName(snapshot),
                                  CustomSizedBox()._sizedBox10,
                                  countryCode(snapshot),
                                  CustomSizedBox()._sizedBox10,
                                  dateTime(),
                                  const SizedBox(height: 10),
                                  imageToday(),
                                  const SizedBox(height: 50),
                                  //Temp wind humudiy yazan kısmın çerçevesi buradan başlar
                                  tempWindHumudityContainer(),
                                  const SizedBox(height: 50),
                                  sevendayWidget(context),
                                ],
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Text('An error occurred while loading data ${snapshot.error}');
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  //ANASAYFADAKİ İCONU APİNİN İÇİNDEN ÇEKTİM
  Image imageToday() {
    String iconUrl = 'https://www.weatherbit.io/static/img/icons/';
    return Image.network(
      '$iconUrl${weatherList[0].weather!.icon.toString()}.png',
      height: 200,
      width: 200,
      fit: BoxFit.cover,
    );
  }

  //Şehir seçmek için oluşturduğum button
  //cityModel diye bir model oluşturdum bütün şehirleri onun içinden çekiyorum
  ElevatedButton selectCityButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber[500],
        fixedSize: const Size(250, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Cities"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: List.generate(cityModel.cities.length, (index) {
                    return SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, cityModel.cities[index]);
                      },
                      child: Text(cityModel.cities[index]),
                    );
                  }),
                ),
              ),
            );
          },
        ).then((value) {
          setState(() {
            //Başta verilen şehri seçilen değer ile değiş
            selectedCity = value;
          });
        });
      },
      child: const Text("Click to select city!"),
    );
  }

  //tıkladığımda verilerin değişmesi için yazılan fonksiyon
  Future<void> onRefresh() async {
    setState(() {
      myWeather = _service.fetchWeather(selectedCity.toLowerCase());
      _service.fetchWeather(selectedCity.toLowerCase()).then((value) {
        if (value != null && value.data != null) {
          setState(() {
            weatherList = value.data!;
            weatherList[0].temp.toString();
            weatherList[0].windSpd.toString();
            weatherList[0].rh.toString();
          });
        }
      });
    });

    return Future<void>.delayed(const Duration(seconds: 1));
  }

  Text cityName(AsyncSnapshot<WeatherModel?> snapshot) {
    return Text(
      snapshot.data!.cityName.toString(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text countryCode(AsyncSnapshot<WeatherModel?> snapshot) {
    return Text(
      snapshot.data!.countryCode.toString(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text dateTime() {
    return Text(
      weatherList[0].datetime.toString(),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Center lottieAsset(String? image) {
    return Center(
      child: Lottie.asset(
        image!,
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  Container tempWindHumudityContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(255, 189, 186, 186),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          temperatureWidget(),
          //aradaki çizgi
          Container(
            width: 1,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
          ),
          windWidget(),
          //aradaki çizgi
          Container(
            width: 1,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
          ),
          humudityWidget(),
        ],
      ),
    );
  }

  ElevatedButton sevendayWidget(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[500],
          fixedSize: const Size(300, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SevenDayPage(),
              ));
        },
        child: const Text(
          'See the 7-Day Weather Forecast',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  Column humudityWidget() {
    return Column(
      children: [
        const Text(
          'Humudity',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        const SizedBox(height: 10),
        Text(
          '${weatherList[0].rh.toString()}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Column windWidget() {
    return Column(
      children: [
        const Text(
          'Wind',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        const SizedBox(height: 10),
        Text(
          '${weatherList[0].windSpd.toString()} km/h',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Column temperatureWidget() {
    return Column(
      children: [
        const Text(
          'Temperature',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        const SizedBox(height: 10),
        Text(
          '${weatherList[0].temp!.truncate().toString()}°C ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CustomSizedBox {
  final SizedBox _sizedBox10 = const SizedBox(height: 10);
  final SizedBox _sizedBox20 = const SizedBox(height: 20);
}
