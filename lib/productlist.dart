import 'package:flutter/material.dart';
import 'package:flutterprjgroup1/checkout.dart';
import 'package:flutterprjgroup1/product.dart';
import 'package:flutterprjgroup1/productcard.dart';

import 'package:flutterprjgroup1/cartprovider.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Hero(
          tag: "logo",
          child: Image.asset('images/logo.png', height: 30),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => CheckoutPage()
                  )
              ),
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: cartProvider.allProducts.length,
        itemBuilder: (context, index) {
          Product product = cartProvider.allProducts[index];
          final isInCart = cartProvider.isInCart(product);
          final quantity = cartProvider.getQuantity(product);

          return ProductCard(
            product,
                () => cartProvider.addToCart(product),
                () => cartProvider.increaseQuantity(product),
                () => cartProvider.decreaseQuantity(product),
            isInCart,
            quantity,
          );
        },
      ),
    );
  }
}
