import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_products_screen.dart';
import 'package:shop_app/screens/manage_products_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail.dart';
import 'package:shop_app/screens/products_overview_screens.dart';
import '../providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Products(),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProvider.value(
            value: Order(),
          ),
        ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepOrangeAccent
        ),
        home: ProductsOverviewScreen(),
        routes:{
          ProductsOverviewScreen.routeName :(ctx)=>ProductsOverviewScreen(),
          ProductDetailScreen.routeName:(ctx)=>ProductDetailScreen(),
          CartScreen.routeName:(ctx)=>CartScreen(),
          MangeProducts.routeName:(ctx)=>MangeProducts(),
          OrdersScreen.routeName:(ctx)=>OrdersScreen(),
          EditScreen.routeName:(ctx)=>EditScreen(),

        } ,
      ),
    );
  }
}


