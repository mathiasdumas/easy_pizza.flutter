import 'package:easy_pizza/screens/like_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_pizza/models/pizza.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class PizzaDetails extends StatelessWidget {
  final Pizza pizza;

  const PizzaDetails ({
    super.key,
    required this.pizza
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                child: Image.asset('images/pizza.png'),
              ),
              Text(
                pizza.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color.fromARGB(255, 111, 54, 244),
                ),
              ),
              Text(
                "${pizza.price.toStringAsFixed(2)}€",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
              Consumer<LikeProvider>(
              builder: (context, likesProvider, child) {
                final isLiked = likesProvider.isLiked(pizza);
                return IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                  color: isLiked ? Colors.red : Colors.grey,
                  onPressed: () {
                    if (isLiked) {
                      likesProvider.unlikePizza(pizza);
                    } else {
                      likesProvider.likePizza(pizza);
                    }
                  },
                );
              }
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                child : Text(
                  "Ingrédients :",
                  style: TextStyle(
                    fontSize: 18,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                child: Column(
                  children: pizza.ingredients.map((ingredient) {
                    return ListTile(
                      title: Text(ingredient),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {context.go('/');},
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}