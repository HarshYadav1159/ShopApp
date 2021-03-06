import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/product_detail.dart';
class ProductItem extends StatelessWidget {
 /*final String id;
 final String title;
 final String imageUrl;

ProductItem( {
  required this.id,
  required this.title,
  required this.imageUrl});*/
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(child: GestureDetector(
        onTap: (){
          Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
              arguments:
              product.id
          );
        },
        child:Image.network(product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),

 footer: GridTileBar(
   leading: Consumer<Product>(
     builder: (ctx,product,child)=>IconButton(
         icon: Icon(product.isFavorite?Icons.favorite:Icons.favorite_border),
         onPressed: (){
           product.toggleFavoriteStatus();
         },
         color: Colors.deepOrange
     ),

   ),
   backgroundColor: Colors.black87,
   title: Text(product.title,textAlign: TextAlign.center,),
  trailing: IconButton(
      icon: Icon(Icons.shopping_cart),
      onPressed: (){
        cart.addItems(product.id, product.price, product.title);
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Added Item to the cart'),
        duration: Duration(seconds: 2),
         action: SnackBarAction(label:'UNDO' , onPressed: (){
           cart.removeSingleProduct(product.id);
         },),
         ),
        );

      },
      color: Colors.deepOrange,
  ),
 ),   ),
    );
  }
}
