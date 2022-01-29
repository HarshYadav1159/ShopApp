import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/app_drawer.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import '../widgets/product_grid.dart';
import 'package:shop_app/widgets/product_item.dart';
import '../models/products.dart';

enum FilterOptions{
  Favorites,
  All,
}
class ProductsOverviewScreen extends StatefulWidget {

  static const routeName='/product-overview';
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
 bool _isInit = true;
 bool _isLoading = false;
  @override
  void didChangeDependencies() {
    if(_isInit){
      _isLoading = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit=false;
    super.didChangeDependencies();
  }

  var showOnlyFavorites=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(

        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue){
                setState(() {
                  if(selectedValue==FilterOptions.Favorites)
                    showOnlyFavorites=true;
                  else
                    showOnlyFavorites=false;
                });

              },
              icon:Icon(Icons.more_vert),
              itemBuilder: (_)=>[
                PopupMenuItem(child: Text('Only Favorites'),value: FilterOptions.Favorites,),
                PopupMenuItem(child: Text('Show All'),value: FilterOptions.All,),
              ],

          ),
          Consumer<Cart>(
            builder: (_,cart,ch)=>
                Badge(value: cart.itemCount.toString(),
                  child: IconButton(
                      icon:Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName,
                            arguments:
                            null

                        );
                      }),
                ),


    ),

        ],


      ),
      body: _isLoading ? Center
        (child: CircularProgressIndicator(),)
          :
      ProductsGrid(showOnlyFavorites),
    );
  }
}
