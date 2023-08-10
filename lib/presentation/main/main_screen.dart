import 'package:animal_cat_ibw_calculator/presentation/main/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _bcsController = TextEditingController();
  String? _bcsErrorText;

  Widget _buildImageWithText({
    required String imageAsset,
    required String scoreText,
    required String scoreText2,
    required String scoreText3,
    required String scoreDescription1,
    required String scoreDescription2,
    required String scoreDescription3,
    required String scoreDescription4,
  }) {
    return Column(
      children: [
        Image.asset(imageAsset,
            width: double.infinity, // 이미지 너비 조절
            height: 150,
            fit: BoxFit.contain // 이미지 높이 조절
            ),
        const SizedBox(height: 10),
        Text(
          scoreText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          scoreText2,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          scoreText3,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          scoreDescription1,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 5),
        Text(
          scoreDescription2,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 5),
        Text(
          scoreDescription3,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 5),
        Text(
          scoreDescription4,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    load();
    _resetFields(); // 앱이 시작될 때마다 값 초기화
  }

  @override
  void dispose() {
    _weightController.dispose();
    _bcsController.dispose();
    super.dispose();
  }

  Future save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', double.parse(_weightController.text));
    await prefs.setDouble('bcs', double.parse(_bcsController.text));
  }

  Future load() async {
    final prefs = await SharedPreferences.getInstance();
    final double? weight = prefs.getDouble('weight');
    final double? bcs = prefs.getDouble('bcs');

    setState(() {
      _weightController.text = weight?.toStringAsFixed(0) ?? ''; // 정수 형식으로 초기화
      _bcsController.text = bcs?.toStringAsFixed(0) ?? ''; // 정수 형식으로 초기화
      _bcsErrorText = null; // 에러 메시지 초기화
    });
  }

  String? _validateBcs(String? value) {
    if (value == null || value.isEmpty) {
      return 'BCS 점수를 입력하세요';
    }

    final bcs = int.tryParse(value);
    if (bcs == null || bcs < 5 || bcs > 40) {
      return 'BCS 점수는 5부터 40까지 입력 가능합니다';
    }

    return null; // 유효성 검사 통과
  }

  Future<void> _resetFields() async {
    setState(() {
      _weightController.text = ''; // 현재 체중 입력 초기화
      _bcsController.text = ''; // BCS 점수 입력 초기화
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('weight'); // 기존에 저장된 체중 데이터 삭제
    await prefs.remove('bcs'); // 기존에 저장된 BCS 점수 데이터 삭제

    setState(() {
      _bcsErrorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 60),
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)),
                      hintText: '현재 체중 kg',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '현재 체중을 입력하세요';
                      }
                      final weight = int.tryParse(value);
                      if (weight == null || weight < 1 || weight > 99) {
                        return '현재 체중은 1부터 99까지 입력 가능합니다';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _bcsController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)),
                      hintText: 'BCS 점수',
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validateBcs,
                    autovalidateMode:
                        _bcsErrorText != null // 에러 메시지가 있을 때만 자동 유효성 검사 활성화
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                    onChanged: (value) {
                      setState(() {
                        _bcsErrorText = null; // 입력이 변경되면 에러 메시지 초기화
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  width: 800,
                                  height: 600,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'BCS 점수 측정법',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Expanded(
                                        child: ListView(
                                          children: [
                                            _buildImageWithText(
                                              imageAsset:
                                                  'assets/cat_image1.1_rate.png',
                                              scoreText:
                                                  '매우 마른 단계 (BCS 1 ~ 2 등급)',
                                              scoreText2: '체지방 비율 1등급 : 5점 이하',
                                              scoreText3: '체지방 비율 2등급 : 5점 이하',
                                              scoreDescription1:
                                                  '육안으로 보았을 때 갈비뼈, 등뼈, 엉덩이뼈가',
                                              scoreDescription2:
                                                  '두드러질 정도로 매우 잘보이며',
                                              scoreDescription3:
                                                  '지방이 거의 없습니다. 정상체중에 비해',
                                              scoreDescription4:
                                                  '40%이상 저체중 상태 입니다.',
                                            ),
                                            _buildImageWithText(
                                              imageAsset:
                                                  'assets/cat_image1.2_rate.png',
                                              scoreText:
                                                  '저체중 단계 (BCS 3 ~ 4 등급)',
                                              scoreText2:
                                                  '체지방 비율 BCS 3등급 : 10점',
                                              scoreText3: '체지방 비율 4등급 : 15점',
                                              scoreDescription1:
                                                  '최소한의 지방이 있으며 갈비뼈, 등뼈가',
                                              scoreDescription2:
                                                  '쉽게 보이고 손으로 만졌을때 뼈가',
                                              scoreDescription3:
                                                  '쉽게 만져집니다. 허리 라인이 눈에 띄고',
                                              scoreDescription4:
                                                  '정상체중에 비해 20% 저체중 상태입니다.',
                                            ),
                                            _buildImageWithText(
                                              imageAsset:
                                                  'assets/cat_image1.33_rate.png',
                                              scoreText: '이상적인 단계 (BCS 5 등급)',
                                              scoreText2:
                                                  '체지방 비율 BCS 5등급 : 20점',
                                              scoreText3: '',
                                              scoreDescription1:
                                                  '눈으로 보았을때 뼈가 잘 보이지 않지만',
                                              scoreDescription2:
                                                  '만졌을 때에는 등뼈와 갈비뼈가 만져집니다.',
                                              scoreDescription3:
                                                  '적당량의 지방이 덮힌 배와 날씬하다고',
                                              scoreDescription4:
                                                  '생각되는 허리 라인이 보입니다.',
                                            ),
                                            _buildImageWithText(
                                              imageAsset:
                                                  'assets/cat_image1.4_rate.png',
                                              scoreText:
                                                  '과체중 단계 (BCS 6 ~ 7 등급)',
                                              scoreText2: '체지방 비율 6등급 : 25점',
                                              scoreText3: '체지방 비율 7등급 : 30점',
                                              scoreDescription1:
                                                  '두꺼운 지방으로 덮혀 있어 뼈가 보이지 않고',
                                              scoreDescription2:
                                                  '만졌을때 갈비뼈를 만지기가 어렵습니다.',
                                              scoreDescription3:
                                                  '움직일 때 마다 지방이 출렁거리고 ',
                                              scoreDescription4:
                                                  '정상체중보다 20%이상 더 나가는 상태입니다.',
                                            ),
                                            _buildImageWithText(
                                              imageAsset:
                                                  'assets/cat_image1.55_rate.png',
                                              scoreText: '비만 단계 (BCS 8 ~ 9 등급)',
                                              scoreText2: '체지방 비율 8등급 : 35점',
                                              scoreText3: '체지방 비율 9등급 : 40점 이상',
                                              scoreDescription1:
                                                  '심각한 지방층이 덮여 있어서 등뼈와 갈비뼈가',
                                              scoreDescription2:
                                                  '만져지지 않고 육안으로 확인이 어렵습니다.',
                                              scoreDescription3:
                                                  '지방으로 인해 허리 라인이 바깥으로 볼록하고',
                                              scoreDescription4:
                                                  '정상체중의 40%이상 과체중 상태입니다.',
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          //
                                        ),
                                        child: const Text(
                                          '닫기',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            //
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // 버튼 배경색상 변경
                        ),
                        child: const Text(
                          'BCS 점수 측정법',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold, // 버튼 글자색 변경
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed:
                                _resetFields, // _resetFields() 메서드를 호출하도록 변경
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.blueAccent,
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: _resetFields,
                                child: Container(
                                  width: 40, // 아이콘의 넓이 조절
                                  height: 40, // 아이콘의 높이 조절
                                  child: const Icon(
                                    Icons.refresh,
                                    size: 24,
                                    color: Colors.white, // 아이콘 색상 설정
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 3),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() == false) {
                                setState(() {
                                  _bcsErrorText = 'BCS 점수를 입력하세요';
                                });
                                return;
                              }
                              save();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoadingScreen(
                                    weight:
                                        double.parse(_weightController.text),
                                    bcs: int.parse(_bcsController.text),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent, // 배경색 설정
                            ),
                            child: const Hero(
                              tag: 'result_button_tag',
                              child: Text(
                                '결과',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold, // 글자색 설정
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
