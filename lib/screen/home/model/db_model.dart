class DbModel {
  String? name, qua, price;
  int? id;
  DbModel(
      {required this.name, required this.qua, required this.price, this.id});
  factory DbModel.mapToModel(Map m1) {
    return DbModel(
        name: m1["name"], qua: m1["qua"], price: m1["price"], id: m1["id"]);
  }
}