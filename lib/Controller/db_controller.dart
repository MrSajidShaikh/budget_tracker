import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Helper/db_helper.dart';

class HomeController extends GetxController {
  RxList data = [].obs;
  RxBool isIncome = false.obs;
  RxDouble totalIncome = 0.0.obs;
  RxDouble totalExpense = 0.0.obs;

  var txtAmount = TextEditingController();
  var txtCategory = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    initDb();
  }

  void setIncome(bool value) {
    isIncome.value = value;
  }

  Future initDb() async {
    await DataBaseHelper.dataBaseHelper.database;
    await getRecords();
  }

  Future insertRecord(double amount, int isIncome, String category) async {
    await DataBaseHelper.dataBaseHelper.insertData(amount, isIncome, category);
    await getRecords();
  }

  Future getRecords() async {
    totalExpense.value = 0.0;
    totalIncome.value = 0.0;
    data.value = await DataBaseHelper.dataBaseHelper.readData();
    for (var i in data) {
      if (i['isIncome'] == 1) {
        totalIncome.value = totalIncome.value + i['amount'];
      } else {
        totalExpense.value = totalExpense.value + i['amount'];
      }
    }
    return data;
  }

  Future removeData(int id) async {
    await DataBaseHelper.dataBaseHelper.deleteData(id);
    await getRecords();
  }
}