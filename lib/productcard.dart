import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterprjgroup1/product.dart';
import 'package:flutterprjgroup1/productdetail.dart';
import 'package:flutterprjgroup1/checkout.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool isInCart;
  final int quantity;

  ProductCard(
      this.product,
      this.onAddToCart,
      this.onIncrease,
      this.onDecrease,
      this.isInCart,
      this.quantity, {
        Key? key,
      }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start with the correct state
    if (widget.isInCart) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isInCart != oldWidget.isInCart) {
      if (widget.isInCart) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showMaxQuantityAlert() {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Limit reached'),
        content: const Text('You can only add up to 10 items.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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
              builder: (context) => ProductDetail(product: widget.product),
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
                child: Hero(
                  tag: widget.product.images.first,
                  child: Image(
                    fit: BoxFit.cover,
                    width: double.infinity,
                    image: AssetImage(widget.product.images.first),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            ' ${widget.product.rating.rate} (${widget.product.rating.count})',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Animated transition between buttons and quantity counter
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Add to Cart/Buy Now buttons
                          Opacity(
                            opacity: 1.0 - _opacityAnimation.value,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CupertinoButton.filled(
                                    onPressed: () {
                                      if (widget.quantity >= 10) {
                                        _showMaxQuantityAlert();
                                      } else {
                                        widget.onAddToCart();
                                      }
                                    },
                                    child: const Text('Add to Cart'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CupertinoButton.filled(
                                    onPressed: () {
                                      if (widget.quantity >= 10) {
                                        _showMaxQuantityAlert();
                                      } else {
                                        widget.onAddToCart();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CheckoutPage(),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Buy Now'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Quantity counter
                          Opacity(
                            opacity: _opacityAnimation.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CupertinoButton.filled(
                                  onPressed: widget.onDecrease,
                                  child: const Icon(Icons.remove),
                                ),
                                Text(widget.quantity.toString()),
                                CupertinoButton.filled(
                                  onPressed: () {
                                    if (widget.quantity >= 10) {
                                      _showMaxQuantityAlert();
                                    } else {
                                      widget.onIncrease();
                                    }
                                  },
                                  child: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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