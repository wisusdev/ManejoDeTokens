import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
	
	GlobalKey<FormState> keyForm = GlobalKey<FormState>();

	String email = '';
	String password = '';

	bool _isLoading = false;

	bool get isLoading => _isLoading;

	set isLoading(bool value){
		_isLoading = value;
		notifyListeners();
	}
	
	bool isFormValid(){
		return keyForm.currentState?.validate() ?? false;
	}
}