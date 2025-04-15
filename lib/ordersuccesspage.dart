import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 24),
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thank you for your purchase',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            CupertinoButton.filled(
                onPressed: () => Navigator.popUntil(context, (route) => route.settings.name == 'ProductList'),
                child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

}
