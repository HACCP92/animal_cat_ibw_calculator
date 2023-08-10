import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double weight;
  final int bcs;

  const ResultScreen({
    Key? key,
    required this.weight,
    required this.bcs,
    required double ibw,
  }) : super(key: key);

  double _calcIbw() {
    return weight * (100 - bcs) / 80;
  }

  Image _buildImage(double ibw) {
    if (ibw > weight) {
      return Image.asset(
        'assets/cat_image1.png',
        width: 200,
        height: 200,
      );
    } else if (ibw == weight) {
      return Image.asset(
        'assets/cat_image2.png',
        width: 200,
        height: 200,
      );
    } else {
      return Image.asset(
        'assets/cat_image3.png',
        width: 200,
        height: 200,
      );
    }
  }

  String _getWeightStatus(double ibw) {
    if (weight < ibw) {
      return '저체중';
    } else if (weight == ibw) {
      return '정상체중';
    } else {
      return '과체중';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ibw = _calcIbw();
    final imageWidget = _buildImage(ibw);
    final weightStatus = _getWeightStatus(ibw);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: 380.0,
              child: Image.asset(
                'assets/cat_image_head4.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 200), // 추가된 부분, AppBar 높이만큼 여백 추가
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '체중 상태 : $weightStatus',
                      style: const TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '현재 체중 : $weight kg',
                      style: const TextStyle(fontSize: 25),
                    ),
                    // 추가된 부분, 체중 상태 표시
                    const SizedBox(width: 16), // 현재 체중과 표준 체중 사이 간격
                    Text(
                      '표준 체중 : ${ibw.toStringAsFixed(1)} kg',
                      style: const TextStyle(fontSize: 25),
                    ),
                  ],
                ),

                imageWidget,

                Container(
                  width: 100, //
                  child: Column(
                    children: [
                      //
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.orangeAccent, // 배경색상 설정
                          shape: BoxShape.circle, //
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.home),
                          color: Colors.white, // 아이콘 색상 설정
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 8), // 아이콘과 이미지 사이 간격
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
