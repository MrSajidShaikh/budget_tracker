import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/db_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.account_circle_outlined),
        title: const Text('Budget Tracker'),
      ),
      body: Obx(
        () => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  controller.totalIncome != 0.0.obs
                      ? 'Total Income: ${controller.totalIncome}'
                      : '',
                  style: const TextStyle(color: Colors.green),
                ),
                Text(
                  controller.totalExpense != 0.0.obs
                      ? 'Total Expense: ${controller.totalExpense}'
                      : '',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.data.length,
                itemBuilder: (context, index) => Card(
                  color: controller.data[index]['isIncome'] == 1
                      ? Colors.green[400]
                      : Colors.red[300],
                  child: ListTile(
                    leading: Text('${index + 1}'),
                    title: Text(controller.data[index]['amount'].toString()),
                    subtitle: Text(controller.data[index]['category']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Update details'),
                                content: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildTextFormField(
                                        label: 'Category',
                                        controller: controller.txtCategory,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      buildTextFormField(
                                        label: 'Amount',
                                        controller: controller.txtAmount,
                                      ),
                                      Obx(
                                        () => SwitchListTile(
                                          activeTrackColor: Colors.green,
                                          title: const Text('Income'),
                                          value: controller.isIncome.value,
                                          onChanged: (value) {
                                            controller.setIsIncome(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      bool response =
                                          formKey.currentState!.validate();
                                      if (response) {
                                        controller.updateRecord(
                                          controller.data[index]['id'],
                                          double.parse(
                                              controller.txtAmount.text),
                                          controller.isIncome.value ? 1 : 0,
                                          controller.txtCategory.text,
                                        );
                                      }
                                      Get.back();
                                      controller.txtAmount.clear();
                                      controller.txtCategory.clear();
                                      controller.isIncome.value = false;
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller
                                .deleteRecord(controller.data[index]['id']);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add details'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildTextFormField(
                      label: 'Category',
                      controller: controller.txtCategory,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTextFormField(
                      label: 'Amount',
                      controller: controller.txtAmount,
                    ),
                    Obx(
                      () => SwitchListTile(
                        activeTrackColor: Colors.green,
                        title: const Text('Income'),
                        value: controller.isIncome.value,
                        onChanged: (value) {
                          controller.setIsIncome(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    bool response = formKey.currentState!.validate();
                    if (response) {
                      controller.initRecord(
                        double.parse(controller.txtAmount.text),
                        controller.isIncome.value ? 1 : 0,
                        controller.txtCategory.text,
                      );
                    }
                    Get.back();
                    controller.txtAmount.clear();
                    controller.txtCategory.clear();
                    controller.isIncome.value = false;
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  TextFormField buildTextFormField({
    required String label,
    required var controller,
  }) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        } else {
          return null;
        }
      },
      cursorColor: Colors.grey,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

var controller = Get.put(DatabaseController());
GlobalKey<FormState> formKey = GlobalKey();
