import 'package:flutter/material.dart';
import 'package:manejo_de_tokens/models/products_model.dart';

class ProductCard extends StatelessWidget {

	final ProductModel product;

  	const ProductCard({Key? key, required this.product}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
    	return Padding(
			padding: EdgeInsets.symmetric(horizontal: 20),
			child: Container(
				margin: EdgeInsets.only(top: 30, bottom: 50),
				width: double.infinity,
				height: 400,
				decoration: _cardBorders(),
				child: Stack(
					alignment: Alignment.bottomLeft,
					children: [
						_backgroundImg(product.picture),

						_productDetails(title: product.name, subtitle: product.id!,),

						Positioned(
							top: 0,
							right: 0,
							child: _priceTag(product.price),
						),

						// TODO: mostrar de manera condicional
						if(!product.available)
						Positioned(
							top: 0,
							left: 0,
							child: _notAvailable(),
						),
					],
				),
			),
		);
  	}

  	BoxDecoration _cardBorders() => BoxDecoration(
		color: Colors.white,
		borderRadius: BorderRadius.circular(25),
		boxShadow: const [
			BoxShadow(
				color: Colors.black38,
				offset: Offset(0, 5),
				blurRadius: 10
			)
		]
	);
}

class _notAvailable extends StatelessWidget {
	const _notAvailable({ Key? key, }) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
    	return Container(
			child: const FittedBox(
				fit: BoxFit.contain,
				child: Padding(
					padding: EdgeInsets.symmetric(horizontal: 10),
					child: Text('No disponible', style: TextStyle(color: Colors.white, fontSize: 20),)
				),
			),
			width: 100,
			height: 70,
			decoration: BoxDecoration(
				color: Colors.yellow[800],
				borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
			),
		);
  	}
}

class _priceTag extends StatelessWidget {

	final double price;

	const _priceTag(this.price);

  	@override
  	Widget build(BuildContext context) {
    	return Container(
			child: FittedBox(
				fit: BoxFit.contain,
				child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 10),
					child: Text('\$$price', style: const TextStyle(color: Colors.white, fontSize: 20),)
				),
			),
			width: 100,
			height: 70,
			alignment: Alignment.center,
			decoration: const BoxDecoration(
				color: Colors.indigo,
				borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
			),
		);
  	}
}

class _productDetails extends StatelessWidget {

	final String title;
	final String subtitle;

  	const _productDetails({required this.title, required this.subtitle});

  	@override
  	Widget build(BuildContext context) {
    	return Padding(
			padding: EdgeInsets.only(right: 50),
			child: Container(
				padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
				width: double.infinity,
				height: 70,
				decoration: _buildBoxDecoration(),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Text(title, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
						Text(subtitle, style: TextStyle(fontSize: 15, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis,),
					],
				),
			),
		);
  	}

  	BoxDecoration _buildBoxDecoration() => const BoxDecoration(
		color: Colors.indigo,
		borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25)),
	);
}

class _backgroundImg extends StatelessWidget {

	final String? url;

	const _backgroundImg(this.url);

  	@override
  	Widget build(BuildContext context) {
    	return ClipRRect(
			borderRadius: BorderRadius.circular(25),
			child: SizedBox(
				width: double.infinity,
				height: 400,
				child: url == null ? Image(image: AssetImage('assets/img/no-image.png'), fit: BoxFit.cover,) : FadeInImage(
					// TODO: fix cuando no haya imagen
					placeholder: AssetImage('assets/img/jar-loading.gif'),
					image: NetworkImage(url!),
					fit: BoxFit.cover,
				),
			),
		);
  	}
}