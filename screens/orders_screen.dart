import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' as ord;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/orders.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
 bool _isLoading=false;
  @override
  void initState() {
   /* Future.delayed(Duration.zero).then((_)async{
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ord.Order>(context,listen: false).fetchOrders();
      setState(() {
        _isLoading = false;
      });
    }  );*/
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    /*final orders = Provider.of<ord.Order>(context);*/
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),

      ),
      body: FutureBuilder(
        future:Provider.of<ord.Order>(context,listen: false).fetchOrders() ,
        builder: (ctx,dataSnapShot){
        if(dataSnapShot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        if(dataSnapShot.connectionState!=null){
          return Center(
            child: Text('An error occured!!'),
          );
        }
        else{
           return Consumer<Order>(
             builder: (ctx,orders,child)=>Column(
                 children:[
                   Expanded(
                     child: ListView.builder(itemBuilder: (ctx,i)=>
                         OrderWidget(
                             orders.item[i],
                             i
                         ),

                       itemCount: orders.item.length,
                     ),
                   ),
                 ]
             ),

           );
        }
      },
      )



    );
  }
}
