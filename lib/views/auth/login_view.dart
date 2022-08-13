import 'package:flutter/material.dart';
import 'package:manejo_de_tokens/providers/login_form_provider.dart';
import 'package:manejo_de_tokens/services/alert_service.dart';
import 'package:manejo_de_tokens/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:manejo_de_tokens/ui/input_decorations.dart';
import 'package:manejo_de_tokens/widgets/auth_background.dart';
import 'package:manejo_de_tokens/widgets/card_container.dart';

class LoginView extends StatelessWidget {
  	const LoginView({Key? key}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
    	return Scaffold(
			body: AuthBackground(
				cardForm: SingleChildScrollView(
					child: Column(
						children: [
							SizedBox(height: 190,),

							CardContainer(
								cardBody: Column(
									children: [
										SizedBox(height: 10,),
										
										Text('Login', style: Theme.of(context).textTheme.headline5,),
										
										SizedBox(height: 30,),

										ChangeNotifierProvider(
											create: (BuildContext context) => LoginFormProvider(),
											child: _loginForm(),
										),
									],
								),
							),
							
							SizedBox(height: 40,),

							TextButton(
								onPressed: () => Navigator.pushReplacementNamed(context, 'register'), 
								style: ButtonStyle(
									overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
									shape: MaterialStateProperty.all(StadiumBorder()),
								),
								child: Text('Crear una nueva cuenta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),),
							),

							SizedBox(height: 50,),
						],
					),
				),
			),
		);
  	}
}

class _loginForm extends StatelessWidget {
	const _loginForm({Key? key}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {

		final loginForm = Provider.of<LoginFormProvider>(context);
		
		return Container(
			child: Form(
				// TODO: mantener la referencia al key
				key: loginForm.keyForm,
				autovalidateMode: AutovalidateMode.onUserInteraction,
				child: Column(
					children: [
						TextFormField(
							autocorrect: false,
							keyboardType: TextInputType.emailAddress,
							decoration: InputDecorations.authInputDecoration(textHint: 'username@mail.com', textLabel: 'Correo', iconPrefix: Icons.alternate_email_sharp),
							validator: (value){
								String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
								RegExp regExp  = new RegExp(pattern);

								return regExp.hasMatch(value ?? '') ? null : 'El correo no es valido';
							},
							onChanged: (value){
								loginForm.email = value;
							},
						), 

						SizedBox(height: 30,),

						TextFormField(
							autocorrect: false,
							obscureText: true,
							enableSuggestions: false,
							keyboardType: TextInputType.emailAddress,
							decoration: InputDecorations.authInputDecoration(textHint: '******', textLabel: 'Contraseña', iconPrefix: Icons.vpn_key),
							validator: (value){
								return (value != null && value.length >= 6) ? null : 'La contraseña debe ser mayor a 6 caracteres';
							},
							onChanged: (value){
								loginForm.password = value;
							},
						),

						SizedBox(height: 30,),

						MaterialButton(
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
							disabledColor: Colors.grey,
							elevation: 0,
							color: Colors.deepPurple,
							child: Container(
								padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
								child: Text(loginForm.isLoading ? 'Cargando' : 'Ingresar', style: TextStyle(color: Colors.white),),
							),
							onPressed: loginForm.isLoading ? null : () async {
								// TODO: submit form
								FocusScope.of(context).unfocus();
								final authService = Provider.of<AuthService>(context, listen: false);

								if( !loginForm.isFormValid() ) return;

								loginForm.isLoading = true;


								// TODO: Validar si el login es correcto
								final String? response = await authService.loginUser(loginForm.email, loginForm.password);
								if( response == null ){
									Navigator.pushReplacementNamed(context, 'home');
								} else {
									print(response);
									AlertService.showSnackbar(response);
									loginForm.isLoading = false;
								}
							},
						)
					],
				)
			),
		);
  	}
}