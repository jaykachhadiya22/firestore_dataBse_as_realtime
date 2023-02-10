import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_time_data_storage/get_realctive_demo/demo_view_modal.dart';

class DemoView extends StatelessWidget {
  DemoView({Key? key}) : super(key: key);
 final DemoViewModal demoViewModal = Get.put(DemoViewModal());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          GetBuilder<DemoViewModal>(
            builder: (controller) {
            return Text("${demoViewModal.cnt}");
          },),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: () {
            demoViewModal.inc();

            Get.find<DemoViewModal>().inc();
          }, child: const Text("Icr"))
        ],
      ),
    );
  }
}
