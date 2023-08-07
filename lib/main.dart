import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'presentation/main/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData(); // 데이터 로딩 시간을 대신할 수 있는 예시 함수입니다.
  }

  void _loadData() async {
    await Future.delayed(const Duration(seconds: 5)); // 2초간 로딩 시뮬레이션
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: _isLoading
          ? Scaffold(
              body: Center(
                // 로딩 화면에 Lottie 애니메이션 추가
                child: Lottie.asset(
                  'assets/lottie/animal_cat.json',
                  width: 300,
                  height: 300,
                ),
              ),
            )
          : const MainScreen(), // 로딩이 끝나면 MainScreen으로 이동
    );
  }
}
