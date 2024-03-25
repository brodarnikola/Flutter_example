import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_example_1/main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/2'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
      } =>
        Album(
          userId: userId,
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

class RestApiExample extends StatefulWidget {
  const RestApiExample({super.key});

  @override
  State<RestApiExample> createState() => _RestApiExample();
}

class _RestApiExample extends State<RestApiExample> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.title);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}


/* import 'package:flutter/material.dart';   
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;  

class Product {
   final String name; 
   final String description;
   final int price;
   final String image; 
   
   Product(this.name, this.description, this.price, this.image); 
   factory Product.fromMap(Map<String, dynamic> json) { 
      return Product( 
         json['name'], 
         json['description'], 
         json['price'], 
         json['image'], 
      );
   }
}

void main() => runApp(MyApp(products: fetchProducts())); 

List<Product> parseProducts(String responseBody) { 
   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>(); 
   return parsed.map<Product>((json) => Product.fromMap(json)).toList(); 
} 
Future<List<Product>> fetchProducts() async { 
   final response = await http.get('http://192.168.1.2:8000/products.json'); 
   if (response.statusCode == 200) { 
      return parseProducts(response.body); 
   } else { 
      throw Exception('Unable to fetch products from the REST API'); 
   } 
}
class MyApp extends StatelessWidget {
   final Future<List<Product>> products; 
   MyApp({Key key, this.products}) : super(key: key); 
   
   // This widget is the root of your application. 
   @override 
   Widget build(BuildContext context) {
      return MaterialApp(
         title: 'Flutter Demo', 
         theme: ThemeData( 
            primarySwatch: Colors.blue, 
         ), 
         home: MyHomePage(title: 'Product Navigation demo home page', products: products), 
      ); 
   }
}
class MyHomePage extends StatelessWidget { 
   final String title; 
   final Future<List<Product>> products; 
   MyHomePage({Key key, this.title, this.products}) : super(key: key); 
   
   // final items = Product.getProducts();
   @override 
   Widget build(BuildContext context) { 
      return Scaffold(
         appBar: AppBar(title: Text("Product Navigation")), 
         body: Center(
            child: FutureBuilder<List<Product>>(
               future: products, builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error); 
                  return snapshot.hasData ? ProductBoxList(items: snapshot.data) 
                  
                  // return the ListView widget : 
                  Center(child: CircularProgressIndicator()); 
               },
            ),
         )
      );
   }
}
class ProductBoxList extends StatelessWidget {
   final List<Product> items; 
   ProductBoxList({Key key, this.items}); 
   
   @override 
   Widget build(BuildContext context) {
      return ListView.builder(
         itemCount: items.length, 
         itemBuilder: (context, index) { 
            return GestureDetector( 
               child: ProductBox(item: items[index]), 
               onTap: () { 
                  Navigator.push(
                     context, MaterialPageRoute( 
                        builder: (context) => ProductPage(item: items[index]), 
                     ), 
                  ); 
               }, 
            ); 
         }, 
      ); 
   } 
} 
class ProductPage extends StatelessWidget { 
   ProductPage({Key key, this.item}) : super(key: key); 
   final Product item; 
   @override 
   Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(title: Text(this.item.name),), 
         body: Center( 
            child: Container(
               padding: EdgeInsets.all(0), 
               child: Column( 
                  mainAxisAlignment: MainAxisAlignment.start, 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: <Widget>[
                     Image.asset("assets/appimages/" + this.item.image), 
                     Expanded( 
                        child: Container( 
                           padding: EdgeInsets.all(5), 
                           child: Column( 
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                              children: <Widget>[ 
                                 Text(this.item.name, style: 
                                    TextStyle(fontWeight: FontWeight.bold)), 
                                 Text(this.item.description), 
                                 Text("Price: " + this.item.price.toString()), 
                                 RatingBox(), 
                              ], 
                           )
                        )
                     ) 
                  ]
               ), 
            ), 
         ), 
      ); 
   } 
}
class RatingBox extends StatefulWidget { 
   @override 
   _RatingBoxState createState() =>_RatingBoxState(); 
} 
class _RatingBoxState extends State<RatingBox> { 
   int _rating = 0; 
   void _setRatingAsOne() {
      setState(() { 
         _rating = 1; 
      }); 
   }
   void _setRatingAsTwo() {
      setState(() {
         _rating = 2; 
      }); 
   }
   void _setRatingAsThree() { 
      setState(() {
         _rating = 3; 
      }); 
   }
   Widget build(BuildContext context) {
      double _size = 20; 
      print(_rating); 
      return Row(
         mainAxisAlignment: MainAxisAlignment.end, 
         crossAxisAlignment: CrossAxisAlignment.end, 
         mainAxisSize: MainAxisSize.max, 
         
         children: <Widget>[
            Container(
               padding: EdgeInsets.all(0), 
               child: IconButton( 
                  icon: (
                     _rating >= 1 
                     ? Icon(Icons.star, ize: _size,) 
                     : Icon(Icons.star_border, size: _size,)
                  ), 
                  color: Colors.red[500], onPressed: _setRatingAsOne, iconSize: _size, 
               ), 
            ), 
            Container(
               padding: EdgeInsets.all(0), 
               child: IconButton(
                  icon: (
                     _rating >= 2 
                     ? Icon(Icons.star, size: _size,) 
                     : Icon(Icons.star_border, size: _size, )
                  ), 
                  color: Colors.red[500], 
                  onPressed: _setRatingAsTwo, 
                  iconSize: _size, 
               ), 
            ), 
            Container(
               padding: EdgeInsets.all(0), 
               child: IconButton(
                  icon: (
                     _rating >= 3 ? 
                     Icon(Icons.star, size: _size,)
                     : Icon(Icons.star_border, size: _size,)
                  ), 
                  color: Colors.red[500], 
                  onPressed: _setRatingAsThree, 
                  iconSize: _size, 
               ), 
            ), 
         ], 
      ); 
   } 
}
class ProductBox extends StatelessWidget {
   ProductBox({Key key, this.item}) : super(key: key); 
   final Product item; 

   
   Widget build(BuildContext context) {
      return Container(
         padding: EdgeInsets.all(2), height: 140, 
         child: Card(
            child: Row( 
               mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
               children: <Widget>[
                  Image.asset("assets/appimages/" + this.item.image), 
                  Expanded( 
                     child: Container( 
                        padding: EdgeInsets.all(5), 
                        child: Column( 
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                           children: <Widget>[ 
                              Text(this.item.name, style:TextStyle(fontWeight: FontWeight.bold)), 
                              Text(this.item.description), 
                              Text("Price: " + this.item.price.toString()), 
                              RatingBox(), 
                           ], 
                        )
                     )
                  )
               ]
            ), 
         )
      ); 
   } 
} */