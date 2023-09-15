import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pagebuild/controller/StampController.dart';
import 'package:flutter_pagebuild/controller/MainController.dart';

class StampView extends StatelessWidget {
  StampView({Key? key}) : super(key: key);

  final controller = Get.find<StampController>();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double blankWidth = screenWidth * 0.25;
    double blankHeight = screenHeight * 0.02;
    double HeaderWidth = screenWidth * 0.05;
    double appbarHeight = screenHeight * 0.12;

    return Scaffold(
      appBar: AppBar(
        title: const HeaderWidget(),
        backgroundColor: Colors.white,
        toolbarHeight: appbarHeight,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              '현재 당근 수 : 2개',
              // '당근 수 {$carrotCnt} / 30'
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: blankHeight,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                ),
                color: Colors.white,
              ),
              width: screenWidth * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    // '\n🥕챌린지 현황🥕\n\n잘하고 있어요! 남은 오늘도 화이팅!\n',
                    '\n🥕챌린지 현황🥕\n\n앗! 야생의 토끼가 나타났어요! \n당근을 지키러 가볼까요?\n',

                    // 소비 x 인 경우
                    // '\n🥕챌린지 현황🥕\n\n잘하고 있어요! 남은 오늘도 화이팅!\n',

                    // 소비 o 인 경우
                    // '\n🥕챌린지 현황🥕\n\n앗! 야생의 토끼가 나타났어요! \n당근을 지키러 가볼까요?\n',

                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            // 달력 위젯
            Stack(
              children: [
                Calendar(),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Stamps(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 로고 누르면 메인으로 돌아가게 함 (기능 추가)
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () {
        var controller = Get.find<StampController>();
        controller.goToMain();
      },
      icon: Image.asset(
        'assets/images/logo-image.png',
        // height: 2000,
      ),
      iconSize: 250,
    );
  }
}

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double stampSize = screenWidth * 0.25;
    return GridView.count(
      padding: const EdgeInsets.all(30),
      crossAxisCount: 3,
      childAspectRatio: 1, // 가로:세로 비율 설정
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
      // physics: FixedExtentScrollPhysics(),
      children: List.generate(30, (index) {
        return Center(
          child: Container(
            decoration: const ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(),
              ),
              color: Color.fromARGB(0, 219, 218, 218),
            ),
            width: stampSize, // 원의 크기를 조절
            height: stampSize, // 원의 크기를 조절
            padding: const EdgeInsets.all(20),
            child: Text(
              '${index + 1} 일차',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }),
    );
  }
}

// 데이터 받을 때마다 이 부분 수정하기
class Stamps extends StatelessWidget {
  const Stamps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(30),
      crossAxisCount: 3,
      childAspectRatio: 1, // 가로:세로 비율 설정
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
      children: List.generate(5, (index) {
        String imageName;
        // 적용예시) n-1 일차가 rabbit 일 때
        // if (index == n-1) {
        //   imageName = 'assets/images/rabbit-stamp.png'; // 첫 번째 이미지
        // }
        if (index == 0) {
          imageName = 'assets/images/rabbit-stamp.png'; // 첫 번째 이미지
        } else if (index == 1) {
          imageName = 'assets/images/rabbit-stamp.png'; // 두 번째 이미지
        } else if (index == 2) {
          imageName = 'assets/images/carrot-stamp.png'; // 세 번째 이미지
        } else if (index == 3) {
          imageName = 'assets/images/carrot-stamp.png'; // 네 번째 이미지
        } else if (index == 4) {
          imageName = 'assets/images/money-stamp.png'; // 다섯 번째 이미지
        } else {
          imageName = '';
        }

        return Center(
          child: Container(
            child: Image.asset(imageName),
          ),
        );
      }),
    );
  }
}

// 수정된 스탬프 받아오기 (달력은 그대로)
class CalendarAndStamps extends StatelessWidget {
  const CalendarAndStamps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Calendar(),
        Stamps(),
      ],
    );
  }
}
