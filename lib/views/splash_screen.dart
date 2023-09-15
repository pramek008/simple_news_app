import 'dart:async';

import 'package:exam_consume_api/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash_pic.jpg',
              fit: BoxFit.cover,
              width: width * 0.9,
              height: height * 0.6,
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Text(
              'NewsApp from API',
              style: GoogleFonts.roboto(
                letterSpacing: 0.6,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            SpinKitChasingDots(
              color: Colors.blue.shade600,
              size: 40.0,
            )
          ],
        ),
      ),
    );
  }
}
