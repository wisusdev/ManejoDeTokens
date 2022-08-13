import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
	final String _baseUrl = 'identitytoolkit.googleapis.com';
	final String _firebaseToken = 'AIzaSyCJFgtpHB380Fo6Qwr6_7r940cbldXws5s'; 
	final storage = const FlutterSecureStorage();


	// Si se hace un retorno es por un error
	Future<String?> registerUser(String email, String password) async {

		final Map<String, dynamic> authData = {
			'email': email,
			'password': password,
			'returnSecureToken' : true
		};

		final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
			'key' : _firebaseToken,
		});

		final response = await http.post(url, body: json.encode(authData));
		final Map<String, dynamic> decodeResponse = json.decode(response.body);
		
		if(decodeResponse.containsKey('idToken')){
			// Se debe guardar el token en un lugar aseguro
			storage.write(key: 'token', value: decodeResponse['idToken']);
			// return decodeResponse['idToken'];
			return null;
		} else {
			return decodeResponse['error']['message'];
		}
	}

	Future<String?> loginUser(String email, String password) async {

		final Map<String, dynamic> authData = {
			'email': email,
			'password': password,
			'returnSecureToken' : true
		};

		final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
			'key' : _firebaseToken,
		});

		final response = await http.post(url, body: json.encode(authData));
		final Map<String, dynamic> decodeResponse = json.decode(response.body);
		
		if(decodeResponse.containsKey('idToken')){
			// Se debe guardar el token en un lugar aseguro
			storage.write(key: 'token', value: decodeResponse['idToken']);
			// return decodeResponse['idToken'];
			return null;
		} else {
			return decodeResponse['error']['message'];
		}
	}

	Future logout() async {
		await storage.delete(key: 'token');

		return;
	}

	Future<String> readToken() async {
		return await storage.read(key: 'token') ?? '';
	}
}