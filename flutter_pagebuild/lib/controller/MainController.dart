import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_pagebuild/controller/RegisController.dart';
import 'package:flutter_pagebuild/view/DetailView.dart';
import 'package:flutter_pagebuild/view/MainView.dart';
import 'package:flutter_pagebuild/view/RankView.dart';
import 'package:flutter_pagebuild/view/StampView.dart';
import 'package:get/get.dart';

//Detail과 Stamp, Main 데이터는 하나 MainModel에 규합
import 'package:flutter_pagebuild/model/MainModel.dart';
import 'package:flutter_pagebuild/model/RankModel.dart';

import 'package:flutter_pagebuild/controller/DetailController.dart';
import 'package:flutter_pagebuild/controller/RankController.dart';
import 'package:flutter_pagebuild/controller/StampController.dart';

import 'package:flutter_pagebuild/DB/service.dart';

class resetMainModel with ChangeNotifier {
  //싱글턴
  static final resetMainModel _inst = resetMainModel._internal();
  static final MainModel mainmodel = MainModel.inst;
  User userlogin = User.getUserlogin;
  resetMainModel._internal() {
    // MainModel.inst.PieChartMap['챌린지 성공'] = MainModel.inst.sucRate;
    // MainModel.inst.PieChartMap['적금 성공'] = MainModel.inst.savinRate;
    // MainModel.inst.PieChartMap['실패'] = MainModel.inst.failRate;
    MainModel.inst.PieChartMap['챌린지 성공'] = 85;
    MainModel.inst.PieChartMap['적금 성공'] = 15;
    MainModel.inst.PieChartMap['실패'] = 0;
  }

  factory resetMainModel() {
    return _inst;
  }

//MainController에서 바꿔야 할 내용
//1. 사용자 명
//2. 챌린지 명
//3. 그래프 % 실시간 계산

  Future<String> get getUser async {
    Map<String, dynamic> getUserinfoMap =
        await getDataMapOf(userlogin.username);
    userlogin.username = getUserinfoMap['고객명'];
    userlogin.challengeName = getUserinfoMap['챌린지목표'];
    userlogin.chkAccount = getUserinfoMap['account'][0];
    userlogin.savings = getUserinfoMap['account'][1];

    mainmodel.challenge = 30;

    mainmodel.stampCnt = getUserinfoMap['stamp']['day'];
    mainmodel.challengeSuc = getUserinfoMap['stamp']['stampCnt'][0];
    mainmodel.challengefail = getUserinfoMap['stamp']['stampCnt'][1];
    mainmodel.savingSuc = getUserinfoMap['stamp']['stampCnt'][2];
    mainmodel.savingBonus = getUserinfoMap['stamp']['stampCnt'][3];
    mainmodel.stampList = await getStampListOf(userlogin.username);
    return userlogin.username;
  }

  Future<void> get resetUser async {
    Map<String, dynamic> getUserinfoMap =
        await getDataMapOf(userlogin.username);
    mainmodel.challenge = 30;
    mainmodel.stampCnt = getUserinfoMap['stamp']['day'];
    mainmodel.challengeSuc = getUserinfoMap['stamp']['stampCnt'][0];
    mainmodel.challengefail = getUserinfoMap['stamp']['stampCnt'][1];
    mainmodel.savingSuc = getUserinfoMap['stamp']['stampCnt'][2];
    mainmodel.savingBonus = getUserinfoMap['stamp']['stampCnt'][3];
    mainmodel.stampList = await getStampListOf(userlogin.username);
  }

//원형 그래프
  void setPieChartMap() async {
    await getUser;
    //챌린지 달성률 업데이트
    MainModel.inst.sucRate =
        MainModel.inst.challengeSuc / MainModel.inst.dayCnt * 100;
    MainModel.inst.failRate =
        MainModel.inst.challengefail / MainModel.inst.dayCnt * 100;
    MainModel.inst.savinRate =
        MainModel.inst.savingSuc / MainModel.inst.dayCnt * 100;
//파이 차트에 필요한 내용만 업데이트
    MainModel.inst.PieChartMap['챌린지 성공'] = MainModel.inst.sucRate;
    MainModel.inst.PieChartMap['적금 성공'] = MainModel.inst.savinRate;
    MainModel.inst.PieChartMap['실패'] = MainModel.inst.failRate;
    notifyListeners();
  }

  void resetPieChartMap() async {
    await getUser;
    //챌린지 달성률 업데이트
    MainModel.inst.sucRate =
        MainModel.inst.challengeSuc / MainModel.inst.dayCnt * 100;
    MainModel.inst.failRate =
        MainModel.inst.challengefail / MainModel.inst.dayCnt * 100;
    MainModel.inst.savinRate =
        MainModel.inst.savingSuc / MainModel.inst.dayCnt * 100;
//파이 차트에 필요한 내용만 업데이트
    MainModel.inst.PieChartMap['챌린지 성공'] = MainModel.inst.sucRate;
    MainModel.inst.PieChartMap['적금 성공'] = MainModel.inst.savinRate;
    MainModel.inst.PieChartMap['실패'] = MainModel.inst.failRate;

//Listener
    notifyListeners();
  }
  //파이 차트에서 필요한 재료는?

//PieChartMap get
  Map<String, double> get getPieChartMap {
    //변동 사항 없으면 그대로 반환
    return MainModel.inst.PieChartMap;
  }

//성공
  String get getSucSavRate {
    //소수점 자리 수
    return MainModel.inst.sucRate.toStringAsFixed(1);
  }

  String get getSucRate {
    //소수점 자리 수
    return MainModel.inst.sucRate.toStringAsFixed(1);
  }

//실패
  String get getFailRate {
    //소수점 자리 수
    return MainModel.inst.failRate.toStringAsFixed(1);
  }

//적금으로 성공
  String get getsavinRate {
    //소수점 자리 수
    return MainModel.inst.savinRate.toStringAsFixed(1);
  }

  trackAccount() {}

  trackSaving() {}

  allcheck() {
    // List<Map<String, dynamic>> = await getTransactionListBetween(String accountNo, String startDate, String startTime,
    //   String endDate, String endTime)
  }

//patchUserData2
  Map<String, dynamic> dataToMap2() {
    Map<String, dynamic> map = {};
    map['고객명'] = userlogin.username;
    Map<String, dynamic> account = {};
    account['0'] = userlogin.chkAccount;
    account['1'] = userlogin.savings;
    map['account'] = account;
    Map<String, dynamic> lastChecked = {};
    lastChecked['0'] = mainmodel.lastChecked_date;
    lastChecked['1'] = mainmodel.lastChecked_time;
    Map<String, dynamic> stamp = {};

    //성공 실패 적금 보너스
    List stampCnt = [
      mainmodel.challengeSuc,
      mainmodel.challengefail,
      mainmodel.savingSuc,
      mainmodel.savingBonus
    ];
    stamp['consum'] = mainmodel.consum;
    stamp['saving'] = mainmodel.saving;
    stamp['day'] = stampCnt[0] + stampCnt[1] + stampCnt[2] + stampCnt[3];
    stamp['stampCnt'] = stampCnt;
    stamp['stampList'] = mainmodel.stampList;
    map['stamp'] = stamp;
    map['챌린지목표'] = userlogin.challengeName;
    map['적금금액'] = 10000;
    return map;
  }

  void checkStamp() async {
    print(userlogin.chkAccount);
    int lastDate = int.parse(mainmodel.lastChecked_date);
    int lastTime = int.parse(mainmodel.lastChecked_time);
    int nowDate = int.parse(mainmodel.now_date);
    int nowTime = int.parse(mainmodel.now_time);
    print('out');
    print(lastDate);
    print(nowDate);
    while (lastDate < nowDate) {
      print('whilein');
      List<String> temp = await getTitleListBetween(
          userlogin.chkAccount,
          lastDate.toString().padLeft(4, '0'),
          lastTime.toString().padLeft(4, '0'),
          (lastDate + 1).toString().padLeft(4, '0'),
          '0000');
      print('test');
      //일단 커피일때만 체크
      for (String s in temp) {
        if (categoryMap[s] != "커피") {
          mainmodel.consum = true;
        }
        if (s.contains('적금')) {
          mainmodel.saving = true;
        }
      }

      List<String> temp2 = await getTitleListBetween(
          userlogin.savings,
          lastDate.toString().padLeft(4, '0'),
          lastTime.toString().padLeft(4, '0'),
          (lastDate + 1).toString().padLeft(4, '0'),
          '0000');

      int idx = lastDate % 100 - 1;
      print('testidx');

      print(idx);
      if (mainmodel.consum && mainmodel.saving) {
        mainmodel.stampList[idx] = 2;
        mainmodel.savingSuc++;
      } else if (!mainmodel.consum && mainmodel.saving) {
        mainmodel.stampList[idx] = 3;
        mainmodel.savingBonus++;
      } else if (mainmodel.consum && !mainmodel.saving) {
        mainmodel.stampList[idx] = 1;
        mainmodel.challengefail++;
      } else {
        mainmodel.stampList[idx] = 0;
        mainmodel.challengeSuc++;
      }

      mainmodel.consum = false;
      mainmodel.saving = false;
      lastDate++;
      mainmodel.stampCnt++;
    }

    List<String> temp = await getTitleListBetween(
        userlogin.chkAccount,
        lastDate.toString().padLeft(4, '0'),
        lastTime.toString().padLeft(4, '0'),
        nowDate.toString().padLeft(4, '0'),
        nowTime.toString().padLeft(4, '0'));

    //일단 커피일때만 체크
    for (String s in temp) {
      if (categoryMap[s] != "커피") {
        mainmodel.consum = true;
        break;
      }
    }

    List<String> temp2 = await getTitleListBetween(
        userlogin.savings,
        lastDate.toString().padLeft(4, '0'),
        lastTime.toString().padLeft(4, '0'),
        nowDate.toString().padLeft(4, '0'),
        nowTime.toString().padLeft(4, '0'));

    if (temp2.isNotEmpty && temp2.contains(10000)) {
      mainmodel.saving = true;
    }

    patchUserData2(dataToMap2(), userlogin.username);

    mainmodel.lastChecked_date = mainmodel.now_date;
    mainmodel.lastChecked_time = mainmodel.now_time;
  }
}

class MainController extends GetxController {
  //reset 모델 - 싱글턴 생성자
  resetMainModel reset = resetMainModel();
  MainModel mainmodel = MainModel.inst;

  //하단부는 페이지 관리
  void getController() {
    Get.lazyPut<DetailController>(() => DetailController());
    Get.lazyPut<RankController>(() => RankController());
    Get.lazyPut<StampController>(() => StampController());
  }

//하단부 -  컨트롤러들
  void goToRank() {
    Get.find<RankController>();
    Get.to(() => RankView());
  }

  void goToDetail() {
    Get.find<DetailController>();
    Get.to(() => DetailView());
  }

  void goToStamp() {
    Get.find<StampController>();
    Get.to(() => StampView());
  }
}
