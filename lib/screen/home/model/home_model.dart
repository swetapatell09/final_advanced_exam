class HomeModel {
  String? name, qua, price;
  int? id;
  HomeModel(
      {required this.name, required this.qua, required this.price, this.id});
  factory HomeModel.mapToModel(Map m1) {
    return HomeModel(
        name: m1["name"], qua: m1["qua"], price: m1["price"], id: m1["id"]);
  }
}