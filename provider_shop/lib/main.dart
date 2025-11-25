import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider_shop/screens/login.dart';
import 'models/catalog.dart';
import 'models/cart.dart';
import 'common/theme.dart';
import 'screens/catalog.dart';
import 'screens/cart.dart';

void main() {
  setupWindow();
  runApp(const MyApp());
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/catalog',
        builder:(context, state) => const CatalogScreen(),
        routes: [
          GoRoute(
            path: 'cart',
            builder: (context, state) => const CartScreen(),  
          )
        ],
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => CatalogModel()),
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            cart!.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Provider Shop',
        theme: appTheme,
        routerConfig: router(),
      ),
    );
  }
}
void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Shop');
    setWindowMinSize(const Size(400, 600));
    setWindowMaxSize(const Size(800, 1200));
    getCurrentScreen().then((screen) {
      if (screen != null) {
        final screenFrame = screen.visibleFrame;
        final width = 600.0;
        final height = 800.0;
        final left = screenFrame.left + (screenFrame.width - width) / 2;
        final top = screenFrame.top + (screenFrame.height - height) / 2;
        setWindowFrame(Rect.fromLTWH(left, top, width, height));
      }
    });
  }
}
