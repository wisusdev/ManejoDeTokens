import 'package:flutter/material.dart';
import 'package:manejo_de_tokens/models/products_model.dart';
import 'package:manejo_de_tokens/services/auth_service.dart';
import 'package:manejo_de_tokens/views/loading_view.dart';
import 'package:provider/provider.dart';
import 'package:manejo_de_tokens/services/products_service.dart';
import 'package:manejo_de_tokens/widgets/product_card.dart';

class HomeView extends StatelessWidget {
		const HomeView({Key? key}) : super(key: key);

		@override
		Widget build(BuildContext context) {

			final productService = Provider.of<ProductsService>(context);
			final authService = Provider.of<AuthService>(context, listen: false);

			if(productService.isLoading) {
				return const LoadingView();
			}

			return Scaffold(
				appBar: AppBar(
					title: const Text('En mi pueblo'),
					actions: [
						IconButton(
							icon: const Icon(Icons.login_outlined),
							onPressed: () {
								authService.logout();
								Navigator.popAndPushNamed(context, 'login');
							},
						),
					]
				),
				body: ListView.builder(
					itemCount: productService.products.length,
					itemBuilder: (BuildContext context, int index) => GestureDetector(
						onTap: (){
							productService.selectedProduct = productService.products[index].copyProduct();
							Navigator.pushNamed(context, 'product');
						},
						child: ProductCard(
							product: productService.products[index],
						)
					),
				),
				floatingActionButton: FloatingActionButton(
					child: const Icon(Icons.add),
					onPressed: (){
						productService.selectedProduct = ProductModel(available: false, name: '', price: 0);
						Navigator.pushNamed(context, 'product');
					},
				),
			);
		}
}