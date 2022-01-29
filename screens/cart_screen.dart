import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/products_overview_screens.dart';
import 'package:shop_app/widgets/cart_item.dart';

import 'orders_screen.dart';
class CartScreen extends StatefulWidget {
  static const routeName='/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<Cart>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
           margin: EdgeInsets.all(15),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text('Total Amount',
                  style: TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                  ),
                  Spacer(),
                  Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                      ),

                  ),
                    backgroundColor: Colors.deepPurple,
                  ),
                  FlatButton(onPressed: (){
                    if(cart.totalAmount!=0){

                             setState(() {
                               Provider.of<Order>(context,listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
                               cart.empty();
                             });
                             showDialog(context: context, builder: (ctx)=>AlertDialog(
                               title: Text('Thank You!!') ,
                               content: Text('Your Order Placed Succesfully'),
                               actions: [
                                 FlatButton(onPressed: ()=>
                                     Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
                                     child: Text('Next'))
                               ],
                             ));


                        /*Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);*/

                    }
                    else{
                      showDialog(context: context, builder: (ctx)=> AlertDialog(
                        title: Text('Attention!'),
                        content: Text('Please add items to the cart'),
                        actions: [
                          FlatButton(onPressed: (){
                            Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName,

                            );
                          },
                              child: Text('OK'))
                        ],
                      ),);
                    }

                  },
                      child: Text('ORDER NOW',style:
                    TextStyle(color: Colors.purple),))
                ] ,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder:(ctx,i)=> CartItems(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,

              ),
            ),
          ),
        ],
      ),
    );
  }
}
