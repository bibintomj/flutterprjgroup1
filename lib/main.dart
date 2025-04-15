import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutterprjgroup1/cartprovider.dart';
import 'package:flutterprjgroup1/productlist.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => CartProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    ColorScheme customColorScheme = const ColorScheme.light(
      primary: Color(0xFFCB202D),
      inversePrimary: Color(0xFFA61A26),
      secondary: Color(0x33CB202D),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: Colors.black87,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SnapBuy",
      theme: ThemeData(
        colorScheme: customColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: customColorScheme.surface,
          foregroundColor: customColorScheme.primary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: customColorScheme.primary,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: customColorScheme.primary,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: customColorScheme.primary),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _calculateScale(double value) {
    double scaleFactor = math.sin(value * 2 * math.pi);
    return 1.0 + (scaleFactor * 0.05);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Text(
                        '⭐️   ',
                        style: TextStyle(fontSize: 40),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 25),
                Hero(
                  tag: "logo",
                  child: Image(
                    width: 300,
                    height: 150,
                    image: AssetImage("images/logo.png"),
                  ),
                ),
                const SizedBox(width: 25),
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Text(
                        '   ⭐️',
                        style: TextStyle(fontSize: 40),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _calculateScale(_animationController.value),
                  child: CupertinoButton.filled(
                    child: const Text("Get Started"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductList(),
                            settings: RouteSettings(name: 'ProductList'),
                      ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}