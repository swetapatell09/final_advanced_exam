class FireStoreModel{
  String? id,name,price,qua;


  FireStoreModel({this.id,required this.name,required this.qua,required this.price});
  factory FireStoreModel.mapToModel(Map m1,String dId)
  {
    return FireStoreModel(id: dId, name: m1["name"], qua: m1["qua"], price: m1["price"]);
  }
}

