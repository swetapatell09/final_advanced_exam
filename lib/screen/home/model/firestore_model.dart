class FireStoreModel{
  String? id,name,dec;
  double? price;

  FireStoreModel({this.id,required this.name,required this.dec,required this.price});
  factory FireStoreModel.mapToModel(Map m1,String dId)
  {
    return FireStoreModel(id: dId, name: m1["name"], dec: m1["dec"], price: m1["price"]);
  }
}

