import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/manage_products.dart';

import 'edit_products_screen.dart';

class MangeProducts extends StatefulWidget {
  const MangeProducts({Key? key}) : super(key: key);
  static const routeName = '/manage-product';
  @override
  _MangeProductsState createState() => _MangeProductsState();
}

class _MangeProductsState extends State<MangeProducts> {
  Future<void> refreshProducts(BuildContext context)async {
    await Provider.of<Products>(context).fetchAndSetProducts();
  }
  @override
  Widget build(BuildContext context) {

    final prod = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Product'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(EditScreen.routeName);
          }, icon: Icon(Icons.add),),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()=>refreshProducts(context),
        child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),

          child:ListView.builder(itemBuilder: (ctx,i)=>
                ManageProduct(
                  prod.items[i].imageUrl,
                  prod.items[i].title,
                  prod.items[i].price,
                  prod.items[i].id,
            ),

              itemCount:prod.items.length,
          ),

        ),
      ),

    );
  }
}
