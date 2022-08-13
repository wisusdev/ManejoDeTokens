import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:manejo_de_tokens/models/products_model.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {

	final String _baseUrl = 'flutter-products-50878-default-rtdb.firebaseio.com';
	final List<ProductModel> products = [];
	late ProductModel? selectedProduct;

	final storage = const FlutterSecureStorage();

	File? newPictureFile;
	
	bool isLoading = true;
	bool isSaving = false; 

	// TODO: hacer el fetch de productos
	ProductsService(){
		loadProducts();
	}

  // TODO: return <List<ProductModel>
	Future<List<ProductModel>> loadProducts() async {
		isLoading = true;
		notifyListeners();

		final url = Uri.https(_baseUrl, 'products.json', {
			'auth' :  await storage.read(key: 'token') ?? '',
		});
		final response = await http.get(url);

		final Map<String, dynamic> productsMap = json.decode( response.body);
		
		productsMap.forEach((key, value) {
			final tempProduct = ProductModel.fromMap(value);
			tempProduct.id = key;
			products.add(tempProduct);
		});

		isLoading = false;
		notifyListeners();

		return products;
	}

  	Future saveOrCreateProduct(ProductModel product) async {
		isSaving = true;
		notifyListeners();

		if(product.id == null){
			await createProduct(product);
		} else {
			await updateProduct(product);
		}

		isSaving = false;
		notifyListeners();
  	}

	Future<String> updateProduct(ProductModel product) async {
		final url = Uri.https(_baseUrl, 'products/${product.id}.json', {
			'auth' :  await storage.read(key: 'token') ?? '',
		});
    	final response = await http.put(url, body: product.toJson());
		final decodeData = response.body;

		// TODO: Actualizar listado de preoductos
		final index = products.indexWhere((element) => element.id == product.id);
		products[index] = product;

		return product.id!;
	}

	Future<String> createProduct(ProductModel product) async {
		final url = Uri.https(_baseUrl, 'products.json', {
			'auth' :  await storage.read(key: 'token') ?? '',
		});
    	final response = await http.post(url, body: product.toJson());
		final decodeData = json.decode(response.body);
		product.id = decodeData['name'];
		products.add(product);

		return product.id!;
	}

	void updateSelectedProductImage(String path){
		selectedProduct!.picture = path;
		newPictureFile = File.fromUri( Uri(path: path) );

		notifyListeners();
	}

	Future<String?> uploadImage() async {
		if(newPictureFile == null) return null;
		
		isSaving = true;
		notifyListeners();

		final url = Uri.parse('https://api.cloudinary.com/v1_1/dcdbsdjto/image/upload?upload_preset=vtzgdv8k');
		final imageUploadRequest = http.MultipartRequest('POST', url,);
		final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);
		
		imageUploadRequest.files.add(file);

		final streamResponse = await imageUploadRequest.send();
		final response = await http.Response.fromStream(streamResponse);

		if(response.statusCode != 200 && response.statusCode != 201){
			return null;
		}

		newPictureFile = null;

		final decodeData = json.decode(response.body);
		return decodeData['secure_url'];
	}

}