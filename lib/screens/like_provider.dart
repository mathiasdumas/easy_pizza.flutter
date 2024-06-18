import 'dart:collection';
import 'package:easy_pizza/models/pizza.dart';
import 'package:flutter/material.dart';

class LikeProvider extends ChangeNotifier{
  final List<Pizza> _items = [];
  
  UnmodifiableListView<Pizza> get items => UnmodifiableListView(_items);

  void likePizza(Pizza pizza){
    _items.add(pizza);

    notifyListeners();
  }

  void unlikePizza(Pizza pizza){
    _items.remove(pizza);

    notifyListeners();
  }

  bool isLiked(Pizza pizza ) {
    return _items.contains(pizza);
  }
}