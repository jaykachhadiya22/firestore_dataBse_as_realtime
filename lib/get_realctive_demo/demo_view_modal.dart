import 'package:get/get.dart';

class DemoViewModal extends GetxController{

  var cnt =0;


  void inc()
  {
    cnt++;
    update();  //will update the count variable on ui which use it
  }
}