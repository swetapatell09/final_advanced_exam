import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/db_helper.dart';
import '../../home/controller/home_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final HomeController controller = Get.put(HomeController());

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
        centerTitle: true,
        title: const Text("Cart", style: TextStyle(color: Colors.blueGrey),),
      ),
      body: Obx(
            () =>
            ListView.builder(
              itemCount: controller.cartList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Get.defaultDialog(
                        title: "Are you Sure",
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              await DbHelper.helper
                                  .deleteCartData(
                                  controller.cartList[index].id!);
                              controller.getCart();
                              Get.back();
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                        ],
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 120,
                      width: 100,
                      decoration:
                      BoxDecoration(color: Colors.blue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${controller.cartList[index].name}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: "f3"),
                        ),
                        Text("\$ ${controller.cartList[index].price}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "f3")),
                        Text("${controller.cartList[index].qua}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "f3")),
                      ],
                    ),
                  ),
                ));
              },
            ),
      ),
    );
  }
}