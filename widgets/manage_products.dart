import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_products_screen.dart';

class ManageProduct extends StatefulWidget{
  final String imageUrl;
  final String title;
  final double price;
  final String id;

  ManageProduct(this.imageUrl,this.title,this.price,this.id);

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  @override
  Widget build(BuildContext context) {
    final products= Provider.of<Products>(context , listen: false);
    return ListTile(
      leading: CircleAvatar(
       backgroundImage: NetworkImage(widget.imageUrl),
      ),
      title: Text(widget.title),
      trailing: Container(
        /*color: Colors.black54,*/
        width: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children:[
            IconButton(
              icon: Icon(Icons.edit,

              color: Colors.purple,),
              onPressed: (){
                Navigator.of(context).pushNamed(EditScreen.routeName,
                arguments:widget.id
                );

              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,color: Colors.red,),
              onPressed: (){
                /*print(widget.id);*/
                products.removeProduct(widget.id);

                },
            ),
          ],
        ),
      ),


    );
  }
}
