import 'package:final_advance_exam/screen/home/model/home_model.dart';
import 'package:get/get.dart';


import '../../../utils/db_helper.dart';
import '../model/db_model.dart';

class HomeController extends GetxController {
  RxList<DbModel> cartList = <DbModel>[].obs;
  RxList<DbModel> dataList = <DbModel>[].obs;
  Future<void> getData() async {
    dataList.value = await DbHelper.helper.readData();

  }
  Future <void> getCart()async
  {
    cartList.value=await DbHelper.helper.readCartData();
  }
}