import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class isSaleController extends GetxController{
RxBool isSale=false.obs;
void toggleIsSale(bool value){
  isSale.value=value;
  update();
}

  void setIsSaleOldValue(bool value) {
    isSale.value = value;
    update();
  }
}