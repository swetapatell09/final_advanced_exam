
import 'package:final_advanced_exam1/utils/firedb_helper.dart';
import 'package:get/get.dart';


import '../../../utils/db_helper.dart';
import '../model/db_model.dart';
import '../model/firestore_model.dart';

class HomeController extends GetxController {
  RxList<DbModel> cartList = <DbModel>[].obs;
  RxList<DbModel> dataList = <DbModel>[].obs;
  RxList<FireStoreModel> list = <FireStoreModel>[].obs;
  Future<void> getData() async {
    dataList.value = await DbHelper.helper.readData();

  }
  Future <void> getCart()async
  {
    cartList.value=await DbHelper.helper.readCartData();
  }
  void getFirebaseData()async
  {
    list.value=await CloudFirestoreHelper.fireDBHelper.readData();
  }
}