import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_advanced_exam1/screen/home/model/firestore_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            child: StreamBuilder(
              stream: CloudFirestoreHelper.fireDBHelper.readData(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                List<FireStoreModel> list = snapshot.data!.docs.map((doc) {
                  return FireStoreModel.mapToModel(doc.data()! as Map<String, dynamic>, doc.id);
                }).toList();

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    FireStoreModel item = list[index];
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
                            "${item.name}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "f3"),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${item.qua}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "f3"),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "\$ ${item.price}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "f3"),
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
                                              .deleteData(item.id!);
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
                                icon: const Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () {
                                  txtName.text = item.name!;
                                  txtPrice.text = item.price!;
                                  txtQua.text = item.qua!;
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
                                        const SizedBox(height: 12),
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
                                        const SizedBox(height: 12),
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
                                        const SizedBox(height: 18),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          String name = txtName.text;
                                          String qua = txtQua.text;
                                          String price = txtPrice.text;
                                          FireStoreModel model = FireStoreModel(
                                            id: item.id,
                                            name: name,
                                            price: price,
                                            qua: qua,
                                          );
                                          CloudFirestoreHelper.fireDBHelper.updateData(model);

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
                                      price: item.price!, qua: item.qua!, name: item.name!);
                                  DbHelper.helper.addCartData(d1);
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
                );
              },
            )
        )
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
                    CloudFirestoreHelper.fireDBHelper.readData();
                    Get.back();
                    txtName.clear();
                    txtQua.clear();
                    txtPrice.clear();
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
