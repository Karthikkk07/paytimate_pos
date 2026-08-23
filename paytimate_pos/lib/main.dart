import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/search_provider.dart';
import 'screens/pos_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // sets up local storage for offline persistence

  final cartProvider = CartProvider();
  await cartProvider.loadFromDisk(); // rehydrate cart before first frame

  runApp(MyApp(cartProvider: cartProvider));
}

class MyApp extends StatelessWidget {
  final CartProvider cartProvider;

  const MyApp({super.key, required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cartProvider),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MaterialApp(
        title: 'Paytimate POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            brightness: Brightness.light,
          ),
        ),
        home: const PosScreen(),
      ),
    );
  }
}
