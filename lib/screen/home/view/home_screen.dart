
import 'package:final_advanced_exam1/screen/home/model/firestore_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../utils/db_helper.dart';
import '../../../utils/firedb_helper.dart';
import '../controller/home_controller.dart';
import '../model/db_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  TextEditingController txtName = TextEditingController();
  TextEditingController txtQua = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.getFirebaseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('cart');
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Products",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
            child: Obx(
          () => ListView.builder(
            itemCount: controller.list.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller.list[index].name}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "f3"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${controller.list[index].qua}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "f3"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\$ ${controller.list[index].price}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "f3"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            Get.defaultDialog(
                              title: "Are you Sure",
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await CloudFirestoreHelper.fireDBHelper
                                        .deleteData(controller
                                            .list[index].id!);
                                    controller.getFirebaseData();
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
                                ),
                              ],
                            );
                          },
                          icon: const Icon(
                            (Icons.delete),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            txtName.text = controller.list[index].name!;
                            txtPrice.text = controller.list[index].price!;
                            txtQua.text = controller.list[index].qua!;
                            Get.defaultDialog(
                              title: "Edit Product",
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: txtName,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter product:";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        label: Text("Product:"),
                                        border: OutlineInputBorder()),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    controller: txtQua,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Quantity:";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      label: Text("Quantity:"),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    controller: txtPrice,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Price:";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        label: Text("Price:"),
                                        border: OutlineInputBorder()),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    String name = txtName.text;
                                    String qua = txtQua.text;
                                    String price = txtPrice.text;
                                    FireStoreModel model =FireStoreModel(
                                      id: controller.list[index].id,
                                      name: name,
                                      price: price,
                                      qua: qua,
                                    );
                                    CloudFirestoreHelper.fireDBHelper
                                        .updateData(model);
                                    
                                    controller.getFirebaseData();
                                    Get.back();
                                    txtPrice.clear();
                                    txtQua.clear();
                                    txtName.clear();
                                  },
                                  child: const Text("Update"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("cancel"),
                                ),
                              ],
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            DbModel d1 = DbModel(
                                price: controller.list[index].price!,
                                qua: controller.list[index].qua!,
                                name: controller.list[index].name!);
                            DbHelper.helper.addCartData(d1);
                            controller.getCart();
                            Get.snackbar("Success", "",
                                backgroundColor: Colors.white,
                                animationDuration: const Duration(seconds: 1));
                          },
                          icon: const Icon(Icons.favorite_border),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ))
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Get.defaultDialog(
            title: "Add a new Product",
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: txtName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Name:";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          label: Text("Name:"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                        controller: txtQua,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Quantity:";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            label: Text("Quantity"),
                            border: OutlineInputBorder())),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: txtPrice,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Price:";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          label: Text("Price:"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                child: const Text("Add"),
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    FireStoreModel f1 = FireStoreModel(
                      name: txtName.text,
                      qua: txtQua.text,
                      price: txtPrice.text,
                    );
                     await CloudFirestoreHelper.fireDBHelper.addData(f1);
                    controller.getFirebaseData();
                    Get.back();
                  }
                },
              )
            ],
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
