import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/products.dart';
import '../screens/product_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Products with ChangeNotifier{
    List<Product> _items =[
      /*Product(
        id: 'p1',
        title: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 29.99,
        imageUrl:
        'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      ),
      Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg'
      ),
      Product(
        id: 'p3',
        title: 'Yellow Scarf',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 19.99,
        imageUrl:
        'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      ),
      Product(
        id: 'p4',
        title: 'A Pan',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      ),*/
    ];


    List<Product> get items{
      return [..._items];
    }

    List<Product> get favoriteItems{
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }

    Product findById(String id){
      return _items.firstWhere((prod) => prod.id==id);
  }

  Future <void> fetchAndSetProducts()async {
      final url = Uri.parse('https://shopapp-1c61d-default-rtdb.firebaseio.com/products.json');
    try{
      final response  =await http.get(url);
      List <Product>loadedProduct = [];
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite']
        ));
      });
       _items = loadedProduct;
       notifyListeners();
    }
    catch(error){
      throw(error);
    }

  }

    Future<void> addProduct(Product product)async {
     final url =  Uri.https('shopapp-1c61d-default-rtdb.firebaseio.com','/products.json');

     try{
       final response = await http.post(url,body: json.encode({
         'title':product.title,
         'description':product.description,
         'imageUrl':product.imageUrl,
         'price':product.price,
         'isFavorite':product.isFavorite,
       }),);
       final newProduct=Product(
         id: json.decode(response.body)['name'],
         title: product.title,
         description: product.description,
         imageUrl: product.imageUrl,
         price: product.price,
       );
       _items.add(newProduct);
       /* _items.add(value);*/
       notifyListeners();
     } catch(error){
       print(error);
       throw(error);
     }
    }

    void removeProduct(String id){
      final url = Uri.parse('https://shopapp-1c61d-default-rtdb.firebaseio.com/products/$id.json');
      final existingProductIndex = _items.indexWhere((prod) =>prod.id==id);
      Product? existingProduct = _items[existingProductIndex];
      _items.removeAt(existingProductIndex);
      http.delete(url).then((_) {
        existingProduct = null;
      }).catchError((error){
          _items.insert(existingProductIndex, existingProduct!);
      });

      notifyListeners();

    }

    Future<void> updateProduct(String id , Product newProduct)async {
      final prodId = _items.indexWhere((prod) => prod.id==id);

      if(prodId>=0){
        final url = Uri.parse('https://shopapp-1c61d-default-rtdb.firebaseio.com/products/$id.json');
        http.patch(url, body:json.encode({
          'title':newProduct.title,
          'price':newProduct.price,
          'isFavorite':newProduct.isFavorite,
          'imageUrl':newProduct.imageUrl,
          'description':newProduct.description,
        }) );
        _items[prodId] = newProduct ;
        notifyListeners();
      }

    }

}