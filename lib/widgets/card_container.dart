import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

	final Widget cardBody;

  	const CardContainer({Key? key, required this.cardBody}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
    	return Padding(
			padding: EdgeInsets.symmetric(horizontal: 30),
			child: Container(
				width: double.infinity,
				padding: EdgeInsets.all(20),
				decoration: _cardShape(),
				child: cardBody,
			),
		);
  	}

  	BoxDecoration _cardShape() => BoxDecoration(
		color: Colors.white,
		borderRadius: BorderRadius.circular(20),
		boxShadow: [
			BoxShadow(
				color: Colors.black12,
				blurRadius: 15,
				offset: Offset(0,5)
			)
		],
	);
}