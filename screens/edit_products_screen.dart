import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/providers/products.dart';

class EditScreen extends StatefulWidget {

  static const routeName = '/edit-product';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  var _isInit =true;
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: '',
      title: '',
      description: '',
      price: 0,
      imageUrl: '');
  var _initValues = {
    'title':'',
    'description':'',
    'price':'',
    'imageUrl':'',
  };
  var _isLoading =false;

  @override
  void initState(){
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final productId= ModalRoute.of(context)!.settings.arguments ;
      if(productId!=null){
        _editedProduct = Provider.of<Products>(context,listen: false).findById(productId.toString());
        _initValues ={
          'title':_editedProduct.title,
          'description':_editedProduct.description,
          'price':_editedProduct.price.toString(),
          /*'imageUrl':_editedProduct.imageUrl*/
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }

    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void dispose(){
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      setState(() {

      });
    }
  }

  void saveForm() async{
    final isValid = _form.currentState!.validate();
    setState(() {
      _isLoading =true;
    });
    if(isValid){
      _form.currentState!.save();
      if(_editedProduct.id!=''){
       await Provider.of<Products>(context,listen: false).updateProduct(_editedProduct.id,_editedProduct);

       Navigator.of(context).pop();
      }
      else{
        try{
          Provider.of<Products>(context,listen: false).addProduct(_editedProduct);
        }
        catch(error){
          return showDialog(context: context, builder: (ctx)=> AlertDialog(
            title: Text('An error Occured'),
            content: Text('Something went wrong'),
            actions: [
              FlatButton(
                onPressed: (){
                  Navigator.of(ctx).pop();
                },
                child: Text('OK'),)
            ],
          ),);
        }
        finally{
          setState(() {
            _isLoading =false;
          });
          Navigator.of(context).pop();
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: saveForm,
              icon: Icon(Icons.save))
        ],
      ),
      body: _isLoading?Center(child: CircularProgressIndicator(),)
          :
      Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,

          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value != null ? value : '',
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please provide a title.';
                  }
                  return null;
                },
              ),
        TextFormField(
          initialValue: _initValues['price'],
          decoration: InputDecoration(labelText: 'Price'),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          focusNode: _priceFocusNode,
          onFieldSubmitted: (_){
            FocusScope.of(context).requestFocus(_descriptionFocusNode);
          },
          onSaved: (value){
            _editedProduct = Product(
                id: _editedProduct.id,
                title: _editedProduct.title,
                description: _editedProduct.description,
                price:double.parse(value != null ? value : '0'),
                imageUrl: _editedProduct.imageUrl,
              isFavorite: _editedProduct.isFavorite,
            );
          },
          validator: (value){
            if(value!.isEmpty){
              return 'Please provide a price.';
            }
            if(double.tryParse(value) == null){
              return 'Please enter a valid number';
            }
            if(double.parse(value)<=0){
              return 'Please enter a number greater than zero';
            }
            return null;
          },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                onSaved: (value){
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value != null ? value : '',
                      price:_editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please provide a description.';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8,right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )
                    ),
                    child: _imageUrlController.text.isEmpty?
                    Text('Enter Url'):
                    FittedBox(
                      child: Image.network(
                          _imageUrlController.text,
                        fit: BoxFit.cover,),),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'ImageUrl'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onSaved: (value){
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description:_editedProduct.description,
                            price:_editedProduct.price,
                            imageUrl:  value != null ? value : '',
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please provide a imageUrl.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_)=>saveForm(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}