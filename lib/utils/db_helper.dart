import 'dart:io';

import 'package:final_advance_exam/screen/home/model/db_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper helper = DbHelper._();
  DbHelper._();
  Database? dataBase;
  Future<Database?> checkDB() async {
    if (dataBase != null) {
      return dataBase;
    } else {
      dataBase = await initDB();
      return dataBase;
    }
  }

  Future<Database> initDB() async {
    Directory d1 = await getApplicationSupportDirectory();
    String path = d1.path;
    String joinPath = join(path, "product.db");
    return openDatabase(joinPath, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE product(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,price TEXT,qua TEXT)');
      db.execute('CREATE TABLE cart(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,price TEXT,qua TEXT)');
    }, version: 1);
  }

  Future<void> addData(DbModel model) async {
    dataBase = await checkDB();
    await dataBase!.insert("product",
        {"name": model.name, "qua": model.qua, "price": model.price});
  }

  Future<void> updateData(DbModel model) async {
    dataBase = await checkDB();
    await dataBase!.update(
        "product", {"name": model.name, "qua": model.qua, "price": model.price},
        where: "id=?", whereArgs: [model.id]);
  }

  Future<void> deleteData(int id) async {
    dataBase = await checkDB();
    await dataBase!.delete("product", where: "id=?", whereArgs: [id]);
  }

  Future<List<DbModel>> readData() async {
    dataBase = await checkDB();
    List<Map> dataList = await dataBase!.rawQuery("SELECT * FROM product");
    List<DbModel> dbList = [];
    dbList = dataList
        .map(
          (e) => DbModel.mapToModel(e),
    )
        .toList();
    return dbList;
  }
  Future<void> addCartData(DbModel model) async {
    dataBase = await checkDB();
    await dataBase!.insert("cart",
        {"name": model.name, "qua": model.qua, "price": model.price});
  }

  Future<void> updateCartData(DbModel model) async {
    dataBase = await checkDB();
    await dataBase!.update(
        "cart", {"name": model.name, "qua": model.qua, "price": model.price},
        where: "id=?", whereArgs: [model.id]);
  }

  Future<void> deleteCartData(int id) async {
    dataBase = await checkDB();
    await dataBase!.delete("cart", where: "id=?", whereArgs: [id]);
  }

  Future<List<DbModel>> readCartData() async {
    dataBase = await checkDB();
    List<Map> dataList = await dataBase!.rawQuery("SELECT * FROM cart");
    List<DbModel> dbList = [];
    dbList = dataList
        .map(
          (e) => DbModel.mapToModel(e),
    )
        .toList();
    return dbList;
  }
}