import 'package:flutter/material.dart';
import 'package:manejo_de_tokens/models/products_model.dart';

class ProductFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProductModel product;

  ProductFormProvider(this.product);

  updateAvailability(bool value){
    product.available = value;
    notifyListeners();
  }
  
  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }
}