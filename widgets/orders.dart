import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatefulWidget {
final OrderItem orderData;
final int i;

OrderWidget(this.orderData,this.i);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
bool _isexpanded = false;

  @override
  Widget build(BuildContext context) {

    return Column(
      children:[
        Card(
          margin: EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text('${widget.i+1}'),
            ),
            title: Text('\$${widget.orderData.price}'),
            subtitle: Text(DateFormat('dd-MM-yyyy').format(widget.orderData.date)),
            trailing: IconButton(
              icon: Icon(_isexpanded?Icons.expand_less:Icons.expand_more),
              onPressed: (){
                setState(() {
                  _isexpanded=!_isexpanded;
                });
              },
            ),
          ),

        ),
        if(_isexpanded)
          Container(height: min(widget.orderData.product.length*20, 180),
          child: ListView(
            children:
              widget.orderData.product.map((prod) =>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(prod.title!),
                  Text('${prod.quantity}x \$${prod.price}')
                ],
              ),
              ).toList(),

          ),
          ),

      ]
    );
  }
}
