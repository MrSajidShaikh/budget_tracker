import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Helper/db_helper.dart';

class DatabaseController extends GetxController {
  RxList data = [].obs;
  var txtAmount = TextEditingController();
  var txtCategory = TextEditingController();
  RxBool isIncome = false.obs;
  RxDouble totalIncome = 0.0.obs;
  RxDouble totalExpense = 0.0.obs;
  Rx<File?> fileImage = Rx<File?>(null);
  Rx<XFile?> xFileImage = Rx<XFile?>(null);

  @override
  void onInit() {
    super.onInit();
    initDb();
  }

  void setIsIncome(bool value) {
    isIncome.value = value;
  }

  Future initDb() async {
    await DatabaseHelper.databaseHelper.database;
  }

  Future<void> initRecord(
      double amount, int isIncome, String category, String img) async {
    await DatabaseHelper.databaseHelper
        .insertData(amount, isIncome, category, img);
    await getRecords();
  }

  Future getRecords() async {
    totalIncome = 0.0.obs;
    totalExpense = 0.0.obs;
    data.value = await DatabaseHelper.databaseHelper.readData();
    for (var check in data) {
      if (check['isIncome'] == 1) {
        totalIncome.value += check['amount'];
      } else {
        totalExpense.value += check['amount'];
      }
    }
    return data;
  }

  Future getRecordsBySearch(String search) async {
    data.value = await DatabaseHelper.databaseHelper.readDataBySearch(search);
    return data;
  }

  Future getCategoryRecord(int isIncome) async {
    data.value = await DatabaseHelper.databaseHelper.readCategoryData(isIncome);
  }

  Future<void> updateRecord(
      int id, double amount, int isIncome, String category, String img) async {
    await DatabaseHelper.databaseHelper
        .updateData(id, amount, isIncome, category, img);
    await getRecords();
  }

  Future<void> deleteRecord(int id) async {
    await DatabaseHelper.databaseHelper.deleteData(id);
    await getRecords();
  }

  void pickImage() {
    fileImage.value = File(xFileImage.value!.path);
  }
}
