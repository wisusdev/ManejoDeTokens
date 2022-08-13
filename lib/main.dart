import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:manejo_de_tokens/views/home_view.dart';
import 'package:manejo_de_tokens/views/product_view.dart';
import 'package:manejo_de_tokens/services/auth_service.dart';
import 'package:manejo_de_tokens/views/auth/login_view.dart';
import 'package:manejo_de_tokens/services/alert_service.dart';
import 'package:manejo_de_tokens/views/auth/register_view.dart';
import 'package:manejo_de_tokens/services/products_service.dart';
import 'package:manejo_de_tokens/views/auth/check_auth_view.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  	const AppState({Key? key}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
    	return MultiProvider(
      		providers: [
				ChangeNotifierProvider(create: (BuildContext context) => AuthService()),
        		ChangeNotifierProvider(create: (BuildContext context) => ProductsService())
      		],
      		child: const MyApp(),
    	);
  	}
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'En Mi Pueblo',
			initialRoute: 'login',
			routes: {
				'checking'	: (BuildContext context) => const CheckAuthView(),
				'login'		: (BuildContext context) => const LoginView(),
        		'register'	: (BuildContext context) => const RegisterView(),
				'home'		: (BuildContext context) => const HomeView(),
				'product'	: (BuildContext context) => const ProductView(),
			},
			scaffoldMessengerKey: AlertService.messengerKey,
			theme: ThemeData.light().copyWith(
				scaffoldBackgroundColor: Colors.grey[300],
				appBarTheme: const AppBarTheme(
					elevation: 0,
					color: Colors.indigo,
				),
				floatingActionButtonTheme: const FloatingActionButtonThemeData(
					backgroundColor: Colors.purpleAccent,
					elevation: 0
				)
			),
		);
	}
}