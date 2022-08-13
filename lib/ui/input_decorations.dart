import 'package:flutter/material.dart';

class InputDecorations {
  	static InputDecoration authInputDecoration({required String textHint, required String textLabel, IconData? iconPrefix}){
    	return InputDecoration(
			enabledBorder: const UnderlineInputBorder(
				borderSide: BorderSide(
					color: Colors.purple,
				)
			),
			focusedBorder: const UnderlineInputBorder(
				borderSide: BorderSide(
					color: Colors.purple,
					width: 2
				)
			),
			hintText: textHint,
			labelText: textLabel,
			labelStyle: const TextStyle(
				color: Colors.grey,
			),
			prefixIcon: iconPrefix != null ? Icon(iconPrefix, color: Colors.purple, size: 21,) : null,
		);
  	}
}