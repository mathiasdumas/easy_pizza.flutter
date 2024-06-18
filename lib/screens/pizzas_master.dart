import 'package:easy_pizza/screens/cart_provider';
import 'package:easy_pizza/screens/like_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/pizzas.dart' as db;
import './pizza_details.dart';
import './cart.dart';

class PizzasMaster extends StatelessWidget {
  const PizzasMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizzas à vendre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: db.pizzas.length,
        itemBuilder: (context, index) {
          final pizza = db.pizzas[index];
          return Consumer2<LikeProvider, CartProvider>(
            builder: (context, likesProvider, cartProvider, child) {
              final isLiked = likesProvider.isLiked(pizza);
              return ListTile(
                title: Text(pizza.name),
                subtitle: Text('Prix: ${pizza.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                      color: isLiked ? Colors.red : null,
                      onPressed: () {
                        if (isLiked) {
                          likesProvider.unlikePizza(pizza);
                        } else {
                          likesProvider.likePizza(pizza);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        cartProvider.addPizza(pizza);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PizzaDetails(pizza: pizza),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
