import 'package:final_advance_exam/screen/home/controller/home_controller.dart';
import 'package:final_advance_exam/screen/home/model/db_model.dart';
import 'package:final_advance_exam/screen/home/model/home_model.dart';
import 'package:final_advance_exam/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());
  TextEditingController txtName = TextEditingController();
  TextEditingController txtQua = TextEditingController();
  TextEditingController txtPrice = TextEditingController();

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed('cart');
              },
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      editContact(controller.dataList[index]);
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Are You Sure?"),
                            content: Text(
                                "${controller.dataList[index]} will be deleted!"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("No!")),
                              ElevatedButton(
                                  onPressed: () {
                                    DbHelper.helper.deleteData(
                                        controller.dataList[index].id!);
                                    controller.getData();
                                    Get.back();
                                  },
                                  child: const Text("Yes!"))
                            ],
                          );
                        },
                      );
                    },
                    leading: IconButton(
                        onPressed: () {
                          DbHelper.helper.addCartData(DbModel(
                              name: controller.dataList[index].name,
                              qua: controller.dataList[index].qua,
                              price: controller.dataList[index].price));
                        },
                        icon: const Icon(Icons.favorite)),
                    title: Text(
                      controller.dataList[index].name!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      controller.dataList[index].qua!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    trailing: Text(
                      controller.dataList[index].price!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  );
                },
                itemCount: controller.dataList.length,
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addProduct();
        },
        child: const Icon(Icons.add),
      ),
    ));
  }

  void addProduct() {
    txtName.clear();
    txtQua.clear();
    txtPrice.clear();
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text("Add a new Product"),
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
                    DbModel model = DbModel(
                      name: txtName.text,
                      qua: txtQua.text,
                      price: txtPrice.text,
                    );
                    await DbHelper.helper.addData(model);
                    await controller.getData();
                    Get.back();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  void editContact(DbModel modelIndex) {
    txtName.text = modelIndex.name!;
    txtQua.text = modelIndex.qua!;
    txtPrice.text = modelIndex.price!;
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text("Edit a Product"),
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
                            label: Text("Quantity:"),
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
                child: const Text("Update"),
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    DbModel model = DbModel(
                        name: txtName.text,
                        qua: txtQua.text,
                        price: txtPrice.text,
                        id: modelIndex.id);
                    await DbHelper.helper.updateData(model);
                    await controller.getData();
                    Get.back();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
