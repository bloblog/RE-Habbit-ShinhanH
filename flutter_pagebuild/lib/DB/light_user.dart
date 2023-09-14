import 'package:http/http.dart' as http;
import 'dart:convert';
import 'light_account.dart';
import 'light_api.dart';
import 'light_balance.dart';
import 'light_transaction.dart';
import 'light_transfer.dart';
import 'light_user.dart';
import 'shb_api.dart';

Map<String, dynamic> userToMap(String name) {
  Map<String, dynamic> map = new Map();
  map['고객명'] = name;
  return map;
}

void initUser(String name) {
  var userMap = userToMap(name);
  Map<String, dynamic> temp = new Map();
  temp['0'] = accountToMap(name, (random.nextInt(100000) + 100000).toString(),
      "입출금계좌", "쏠편한입출금통장", 100000, 0);
  temp['1'] = accountToMap(name, (random.nextInt(100000) + 100000).toString(),
      "자유적금", "쏠편한작심3일적금", 0, 0);
  userMap['계좌목록'] = temp;
  patchToFirebase('user', userMap);
  for (var item in userMap['계좌목록'].entries) {
    initAccount(item.value);
  }
}

void patchUser(name) {
  patchToFirebase('user', userToMap(name));
}

void patchUserByAccount(account) {}

void main() {
  test();
}

void test() {
  List lastNameList = ["김", "이", "박", "최", "정"];
  List firstNameList = ["쏠", "몰리", "리노", "슈", "도레미", "서퍼", "플리", "레이"];
  var name = lastNameList[random.nextInt(lastNameList.length)] +
      firstNameList[random.nextInt(firstNameList.length)];
  initUser(name);
}
