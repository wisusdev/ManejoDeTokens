import 'dart:convert';

class ProductModel {
	ProductModel({ required this.available, required this.name, this.picture, required this.price, this.id });

	bool available; 
	String name;
	String? picture;
	double price;
  String? id;

	factory ProductModel.fromJson(String str) => ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

	factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
		available: json["available"],
		name: json["name"],
		picture: json["picture"],
		price: json["price"].toDouble(),
	);

	Map<String, dynamic> toMap() => {
		"available": available,
		"name": name,
		"picture": picture,
		"price": price,
	};

  ProductModel copyProduct() => ProductModel (
    available: available,
    name: name,
    picture: picture,
    price: price,
    id: id,
  );
}
