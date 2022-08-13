import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manejo_de_tokens/providers/product_form_provider.dart';
import 'package:manejo_de_tokens/services/products_service.dart';
import 'package:manejo_de_tokens/ui/input_decorations.dart';
import 'package:manejo_de_tokens/widgets/product_img.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductView extends StatelessWidget {
		const ProductView({Key? key}) : super(key: key);

		@override
		Widget build(BuildContext context) {

			final productService = Provider.of<ProductsService>(context);

			return ChangeNotifierProvider(
				create: (BuildContext context) => ProductFormProvider(productService.selectedProduct!),
				child: _productViewBody(productService: productService),
			);
		}
}

class _productViewBody extends StatelessWidget {
  const _productViewBody({ Key? key, required this.productService, }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
	final productForm = Provider.of<ProductFormProvider>(context);
	
    return Scaffold(
    	body: SingleChildScrollView(
			//keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    		child: Column(
    			children: [
    				Stack(
    					children: [
    						ProductImage(url: productService.selectedProduct!.picture,),

    						Positioned(
    							top: 60,
    							left: 20,
    							child: IconButton(
    								onPressed: () => Navigator.of(context).pop(), 
    								icon: const Icon(Icons.arrow_back, size: 40, color: Colors.white,),
    							)
    						),

    						Positioned(
    							top: 60,
    							right: 20,
    							child: IconButton(
    								onPressed: () async {
    									// TODO: Galeria de imagenes
										final picker = ImagePicker();
										final XFile? pickedFile = await picker.pickImage( 
											source: ImageSource.camera,
											imageQuality: 100,
										);

										if(pickedFile == null){
											print('No se selecciono nada');
											return;
										}

										productService.updateSelectedProductImage(pickedFile.path);
    								}, 
    								icon: const Icon(Icons.camera_alt, size: 40, color: Colors.white,),
    							)
    						)
    					],
    				),
    				_formProduct(), 
    				SizedBox(height: 100,)
    			],
    		),
    	),
    	floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    	floatingActionButton: FloatingActionButton(
    		child: productService.isSaving ? const CircularProgressIndicator(color: Colors.white,) : const Icon(Icons.save),
    		onPressed: productService.isSaving ? null : () async {
				if(!productForm.isValidForm()) return;

				final String? imageUrl = await productService.uploadImage();

				if(imageUrl != null){
					productForm.product.picture = imageUrl;
				}

				await productService.saveOrCreateProduct(productForm.product);
    		},
    	),
    );
  }
}

class _formProduct extends StatelessWidget {
	const _formProduct({ Key? key, }) : super(key: key);

	@override
	Widget build(BuildContext context) {

		final productForm = Provider.of<ProductFormProvider>(context);
		final product = productForm.product;

		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 10),
			child: Container(
				padding: const EdgeInsets.symmetric(horizontal: 20),
				width: double.infinity,
				decoration: _buildBoxDecoration(),
				child: Form(
					key: productForm.formKey,
					autovalidateMode: AutovalidateMode.onUserInteraction,
					child: Column(
						children: [
							const SizedBox(height: 10,),

							TextFormField(
								initialValue: product.name,
								onChanged: (value) => product.name = value,
								validator: (value){
									if(value == null || value.isEmpty){
										return 'El nombre del producto es obligatorio';
									}
								},
								decoration: InputDecorations.authInputDecoration(textHint: 'Nombre del producto', textLabel: 'Nombre:',),
							),

							const SizedBox(height: 30,),

							TextFormField(
								initialValue: '${product.price}',
								inputFormatters: [
									FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
								],
								onChanged: (value){
									if(double.tryParse(value) == null){
										product.price == 0;
									} else {
										product.price = double.parse(value);
									}
								},
								keyboardType: TextInputType.number,
								decoration: InputDecorations.authInputDecoration(textHint: '\$150', textLabel: 'Precio:',),
							),

							const SizedBox(height: 30,),

							SwitchListTile(
								value: product.available, 
								title: const Text('Disponible'),
								activeColor: Colors.indigo,
								onChanged: productForm.updateAvailability,
							),

							const SizedBox(height: 30,),
						],
					)
				),
			),
		);
	}

	BoxDecoration _buildBoxDecoration() => BoxDecoration(
		color: Colors.white,
		borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
		boxShadow: [
			BoxShadow(
				color: Colors.black.withOpacity(0.05),
				offset: const Offset(0, 5),
				blurRadius: 5
			),
		]
	);
}