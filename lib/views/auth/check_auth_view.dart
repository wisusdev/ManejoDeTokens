import 'package:flutter/material.dart';
import 'package:manejo_de_tokens/services/auth_service.dart';
import 'package:manejo_de_tokens/views/auth/login_view.dart';
import 'package:manejo_de_tokens/views/home_view.dart';
import 'package:manejo_de_tokens/views/loading_view.dart';
import 'package:provider/provider.dart';

class CheckAuthView extends StatelessWidget {
  	const CheckAuthView({Key? key}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
		
		final authService = Provider.of<AuthService>(context, listen: false);

    	return Scaffold(
			body: Center(
				child: FutureBuilder(
					future: authService.readToken(),
					builder: (BuildContext context, AsyncSnapshot<String> snapshot){
						if (!snapshot.hasData) {						  
							return LoadingView();
						}

						if (snapshot.data == '') {  
							Future.microtask((){
								Navigator.pushReplacement(context, PageRouteBuilder(
									pageBuilder: (_, __, ___) => LoginView(),
									transitionDuration: Duration(seconds: 0)
								));
							});
						} else {
							Future.microtask((){
								Navigator.pushReplacement(context, PageRouteBuilder(
									pageBuilder: (_, __, ___) => HomeView(),
									transitionDuration: Duration(seconds: 0)
								));
							});
						}

						return Container();
					}
				),
			),
		);
  	}
}