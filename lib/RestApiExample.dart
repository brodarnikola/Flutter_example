import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_example_1/local_storage/hive_example/hive_screen.dart';
import 'package:flutter_example_1/main.dart'; 
import 'package:http/http.dart' as http;

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
  List<String> myHiveData = ["Local storage", "Firebase", "Google maps"];

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Extra screens"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: List.generate(myHiveData.length, (index) {
            final userData = myHiveData[index];
            return Card(
              child: ListTile(
                title: //Show Name of user stored in data base
                    Text("Name : $userData "),
                subtitle: //Show Email of user stored in data base
                    Text("Description : $userData"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // To edit the data stored
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HiveScreen()),
                          );
                          // showForm(userData["key"]);
                        },
                        icon: const Icon(Icons.edit_note_rounded)),
                  ],
                ),
              ),
            );
          }).toList()),
        ));
    /*  return  
      FutureBuilder<Album>(
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
      );  */
  }
}
