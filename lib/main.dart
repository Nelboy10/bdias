import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/products_page.dart';
import 'pages/add_product_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const AbdiasApp());
}

class AbdiasApp extends StatelessWidget {
  const AbdiasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abdias - Agriculture Intelligente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: const Color(0xFFF5F9F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/products': (context) => const ProductsPage(),
        '/add-product': (context) => const AddProductPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
