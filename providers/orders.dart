import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
class OrderItem{

 final double price;
 final List<CartItem> product;
 final String id;
 final DateTime date;


  OrderItem({ required this.price, required this.product,required this.id,required this.date});

}
class Order extends ChangeNotifier{
List <OrderItem> _item = [];

List<OrderItem> get item{
  return[..._item];
}

Future<void> fetchOrders()async{
  final url = Uri.parse('https://shopapp-1c61d-default-rtdb.firebaseio.com/orders.json');
  final List<OrderItem>loadedOrders=[];
  final response  =await http.get(url);
  final extractedData = json.decode(response.body) as Map<String,dynamic>;
 // print(response.statusCode);

  extractedData.forEach((ordId, orderData) {
    loadedOrders.add(OrderItem(
        product:(orderData['products']as List<dynamic?>).map((item) =>CartItem(
            id:item['id'],
            title: item['title'],
            price: item['price'],
            quantity: item['quantity'])).toList() ,
        price: orderData['amount'],
        id: ordId,
        date: DateTime.parse(orderData['date']),
    ),);
  });
  _item=loadedOrders;
 notifyListeners();
}


  Future<void> addOrder(List<CartItem> product,double amount)async {
  final url = Uri.https('shopapp-1c61d-default-rtdb.firebaseio.com','/orders.json');
  final timesstamp=DateTime.now();
  http.post(url,body: json.encode({
    /*'CartItem':product,*/
    'amount': amount,
    'product':product.map((cp) =>{
    'id':cp.id,
    'title':cp.title,
    'quantity':cp.quantity,
    'price':cp.price,
  }).toList(),
    'Date':timesstamp.toIso8601String(),
  })).then((value) {
    _item.insert(0,
      OrderItem(
        id: DateTime.now().toString(),
        price: amount,
        product: product,
        date: DateTime.now(),
      ),
    );

    notifyListeners();
  });

  }
}