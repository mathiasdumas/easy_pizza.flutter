import 'dart:convert';

import 'package:easy_pizza/models/discount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketProvider with ChangeNotifier{
  final WebSocketChannel channel;
  Discount? currentDiscourd;

  WebsocketProvider() : channel = WebSocketChannel.connect(Uri.parse(dotenv.env["WEBSOCKET_API"]!)){
  _listenForDiscourd();
  }

  void _listenForDiscourd(){
    channel.sink.add(jsonEncode({
      "collection": "discounts",
      "type": "subscribe",
    })); 


    channel.stream.listen((message){
      final data = jsonDecode(message);
      if (data["collection"] == "discounts"){
        final discount = Discount.fromJson(data["payload"]);
        if (DateTime.now().isAfter(discount.start) && DateTime.now().isBefore(discount.end)){
          currentDiscourd = discount;
          notifyListeners();
        }
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}