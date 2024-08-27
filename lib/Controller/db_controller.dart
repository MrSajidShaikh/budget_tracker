import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Helper/db_helper.dart';

class DatabaseController extends GetxController {
  RxList data = [].obs;
  var txtAmount = TextEditingController();
  var txtCategory = TextEditingController();
  RxBool isIncome = false.obs;
  RxDouble totalIncome = 0.0.obs;
  RxDouble totalExpense = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    initDb();
  }

  void setIsIncome(bool value){
    isIncome.value = value;
  }

  Future initDb() async {
    await DatabaseHelper.databaseHelper.database;
  }

  Future<void> initRecord(double amount, int isIncome, String category) async {
    await DatabaseHelper.databaseHelper.insertData(amount, isIncome, category);
    await getRecords();
  }

  Future getRecords() async {
    totalIncome = 0.0.obs;
    totalExpense = 0.0.obs;
    data.value = await DatabaseHelper.databaseHelper.readData();
    for(var check in data){
      if(check['isIncome'] == 1){
        totalIncome.value += check['amount'];
      } else{
        totalExpense.value += check['amount'];
      }
    }
    return data;
  }

  Future<void> updateRecord(
      int id, double amount, int isIncome, String category) async {
    await DatabaseHelper.databaseHelper
        .updateData(id, amount, isIncome, category);
    await getRecords();
  }

  Future<void> deleteRecord(int id) async {
    await DatabaseHelper.databaseHelper.deleteData(id);
    await getRecords();
  }
}
