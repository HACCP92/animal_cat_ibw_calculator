import 'dart:async';
import 'package:animal_cat_ibw_calculator/presentation/result/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatefulWidget {
  final double weight;
  final int bcs;

  const LoadingScreen({
    Key? key,
    required this.weight,
    required this.bcs,
  }) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _calcIbw() {
    return widget.weight * (100 - widget.bcs) / 100;
  }

  bool animationStarted = false; //

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        animationStarted = true;
      });
    });

    Timer(const Duration(seconds: 2), () {
      final double ibw = _calcIbw();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            weight: widget.weight,
            bcs: widget.bcs,
            ibw: ibw,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          //
          alignment: Alignment.center,
          children: [
            if (animationStarted) //
              Lottie.asset(
                'assets/lottie/animal_cat.json',
                width: 300,
                height: 300,
              ),
          ],
        ),
      ),
    );
  }
}
