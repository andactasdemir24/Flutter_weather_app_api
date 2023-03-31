import 'package:flutter/material.dart';
import 'package:flutter_weather_app/pages/home_page.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 109, 108, 136),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Lottie.asset(
            'assets/lottie/splash_animation.json',
            height: 250,
            width: 250,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
