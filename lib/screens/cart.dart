// ./lib/screens/cart.dart

import 'package:easy_pizza/screens/cart_provider';
import 'package:easy_pizza/screens/websocket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
      ),
      body: Consumer2<CartProvider, WebsocketProvider>(
        builder: (context, cartProvider, websocketProvider,child) {
          final discount = websocketProvider.currentDiscourd;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (discount != null){
              final now = DateTime.now();
              if (now.isAfter(discount.start) && now.isBefore(discount.end)){
                SnackBar(
                  content: Text("Code promo : ${discount.code}\nRègle: ${discount.rule}\nValable du ${discount.start} au ${discount.end}"),
                  duration: const Duration(seconds: 10),
                );
              }
            }
          });
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.items.values.toList()[index];
                    return ListTile(
                      title: Text(cartItem.pizza.name),
                      subtitle: Text('Taille: ${cartItem.pizza.size} - Prix: ${cartItem.pizza.price.toStringAsFixed(2)}€'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              cartProvider.removePizza(cartItem.pizza.id);
                            },
                          ),
                          Text(cartItem.quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              cartProvider.addPizza(cartItem.pizza);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cartProvider.removeAllPizza(cartItem.pizza.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: "Code Promo",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: (){
                      if (discount != null && _codeController.text == discount.code){
                        double reduction = cartProvider.totalAmount * 0.10;
                        double newTotal = cartProvider.totalAmount - reduction;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:  Text("Reduction appliquée, nouveau totale : ${newTotal.toStringAsFixed(2)}"),
                            duration: const Duration(seconds: 10),
                          )
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Code promo invalide"),
                            duration: Duration(seconds: 10),
                            )
                        );
                      }
                    })
                  ]
                )
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: ${cartProvider.totalAmount.toStringAsFixed(2)}€', style: const TextStyle(fontSize: 20)),
                    ElevatedButton(
                      onPressed: () {
                      },
                      child: const Text('Valider le panier'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
