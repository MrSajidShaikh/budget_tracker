import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/db_controller.dart';

var controller = Get.put(HomeController());

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Data'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller.txtAmount,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      focusColor: Colors.green,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  TextField(
                    controller: controller.txtCategory,
                    decoration: InputDecoration(
                      hintText: 'Category',
                      focusColor: Colors.green,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Obx(
                        () => SwitchListTile(
                      title: const Text(
                        'Income/Expense',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: controller.isIncome.value,
                      onChanged: (value) {
                        controller.setIncome(value);
                      },
                    ),
                  )
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    minimumSize: const Size(100, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: .75),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    double amount = double.parse(controller.txtAmount.text);
                    int isIncome = controller.isIncome.value ? 1 : 0;
                    String category = controller.txtCategory.text;
                    controller.insertRecord(amount, isIncome, category);
                    controller.txtAmount.clear();
                    controller.txtCategory.clear();
                    controller.setIncome(false);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    minimumSize: const Size(100, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: .75),
                  ), // Button ka text
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(
            () => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: Colors.green.shade300,
                  child: SizedBox(
                    width: w * 0.45,
                    height: h * 0.045,
                    child: Center(
                      child: Text(
                        controller.totalIncome.value.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.red.shade300,
                  child: SizedBox(
                    width: w * 0.45,
                    height: h * 0.045,
                    child: Center(
                      child: Text(
                        controller.totalExpense.value.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: controller.data[index]['isIncome'] == 1
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    child: ListTile(
                      leading: Text(
                        controller.data[index]['id'].toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle:
                      Text(controller.data[index]['category'].toString()),
                      title: Text(controller.data[index]['amount'].toString()),
                      trailing: IconButton(
                        onPressed: () {
                          controller.removeData(
                            int.parse(
                              controller.data[index]['id'].toString(),
                            ),
                          );
                        },
                        icon: const Icon((Icons.delete)),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
