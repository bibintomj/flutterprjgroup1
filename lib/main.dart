import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterprjgroup1/productlist.dart';

void main() {
  runApp(const MyApp());
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
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 300,
              height: 150,
              image: AssetImage("images/logo.png"),
            ),
            CupertinoButton.filled(
              child: const Text("Get Started"),
              onPressed:
                  () => {
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => ProductList()
                        )
                    )
                  },
            ),
          ],
        ),
      ),
    );
  }
}
