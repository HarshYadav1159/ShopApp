import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screens.dart';

import 'manage_products_screen.dart';

class AppDrawer extends StatelessWidget {

  Widget buildListTile(String text , IconData icon , VoidCallback tapHandler ){
    return ListTile(
      leading: Icon(icon , size: 30,),
      title: Text(text),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            color: Colors.deepPurple,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Text('Shop!',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
          ),

          buildListTile('Shop ', Icons.shopping_basket , (){
            Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
          },),

          Divider(thickness: 0.8,),

          buildListTile('Manage Products', Icons.account_balance_wallet , (){
            Navigator.of(context).pushNamed(MangeProducts.routeName);
          },),

          Divider(thickness: 0.2,),

          buildListTile('Your orders', Icons.shopping_cart, (){
            Navigator.of(context).pushNamed(OrdersScreen.routeName);
          },),
        ],
      ),


    );
  }
}
