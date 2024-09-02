import 'package:final_advance_exam/screen/home/controller/home_controller.dart';
import 'package:final_advance_exam/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body:  Obx(() =>ListView.builder(
          itemCount: controller.cartList.length,
          itemBuilder: (context, index) {
        return  ListTile(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Are You Sure?"),
                    content: Text(
                        "${controller.cartList[index]} will be deleted!"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("No!")),
                      ElevatedButton(
                          onPressed: () {
                            DbHelper.helper.deleteCartData(
                                controller.cartList[index].id!);
                            controller.getCart();
                            Get.back();
                          },
                          child: const Text("Yes!"))
                    ],
                  );
                },
              );
            },
            title: Text(
              controller.cartList[index].name!,
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              controller.cartList[index].qua!,
              style: const TextStyle(fontSize: 20),
            ),
            trailing: Text(
              controller.cartList[index].price!,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );

            },

            ),
      ),
    );
  }
}
