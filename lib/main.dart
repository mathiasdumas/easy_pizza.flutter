import 'package:easy_pizza/models/pizza.dart';
import 'package:easy_pizza/screens/cart_provider';
import 'package:easy_pizza/screens/like_provider.dart';
import 'package:easy_pizza/screens/pizza_details.dart';
import 'package:easy_pizza/screens/pizzas_master.dart';
import 'package:easy_pizza/screens/websocket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_pizza/data/pizzas.dart' as db;
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => LikeProvider(),
      child: const MainApp()),
    );
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const PizzasMaster();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:pizzaId',
          builder: (BuildContext context, GoRouterState state) {
            final String? pizzaId = state.pathParameters['pizzaId'];
            Pizza pizzaWithId = db.pizzas.firstWhere((element) => element.id == pizzaId);
            return PizzaDetails(pizza: pizzaWithId);
          }
        )
      ]
    )
  ]
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LikeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WebsocketProvider()),
      ],
      child: MaterialApp.router(
      routerConfig: _router,
      ),
    );
  }
}
