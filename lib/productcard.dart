import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterprjgroup1/product.dart';
import 'package:flutterprjgroup1/productdetail.dart';

class ProductCard extends StatelessWidget {
  Product product;
  VoidCallback onAddToCart;
  VoidCallback onIncrease;
  VoidCallback onDecrease;
  bool isInCart;
  int quantity;

  ProductCard(
    this.product,
    this.onAddToCart,
    this.onIncrease,
    this.onDecrease,
    this.isInCart,
    this.quantity,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!isInCart)
                    CupertinoButton.filled(
                      onPressed: onAddToCart,
                      child: const Text('Add to Cart'),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton.filled(
                          onPressed: onDecrease,
                          child: const Icon(Icons.remove),
                        ),
                        Text(quantity.toString()),
                        CupertinoButton.filled(
                          onPressed: onIncrease,
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
