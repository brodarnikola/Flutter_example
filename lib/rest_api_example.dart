import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_example_1/local_storage/hive_example/hive_screen.dart';
import 'package:flutter_example_1/main.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
// very nice example of handling multiple async rest api calls
  exampleMultipleAsyncCalls();

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

Future<int> delete() {
  // Imagine that this function is more complex and slow.
  final intResult = Future.delayed(const Duration(seconds: 2), () =>  
    1
  );
  print("ASYNC OPERATION.. delete is done");
  return intResult;
}

// example of single line function
Future<String> copy() {
 final stringResult = Future.delayed(const Duration(seconds: 1), () => "1"); 
  print("ASYNC OPERATION.. copy is done");
  return stringResult;
} 
Future<bool> errorResult() =>
    Future.delayed(const Duration(seconds: 3), () => true);

void exampleMultipleAsyncCalls() async {
  try {
    // Wait for each future in a record, returns a record of futures:
    (int, String, bool) result = await (delete(), copy(), errorResult()).wait;

    // Do something with the results:
    var deleteInt = result.$1;
    var copyString = result.$2;
    var errorBool = result.$3;
    print("ASYNC OPERATION.. delete is: $deleteInt");
    print("ASYNC OPERATION.. copyString is: $copyString");
    print("ASYNC OPERATION.. errorBool is: $errorBool");
  } on ParallelWaitError<(int?, String?, bool?),
      (AsyncError?, AsyncError?, AsyncError?)> catch (e) {
        print(e.values.$1);
        print(e.errors.$2);
        print(e.errors.$3);

    print("delete is: ${e.values.$1}");
    print("copyString is: ${e.errors.$2}");
    print("errorBool is: ${e.errors.$3}");
    // ...
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
  List<String> myHiveData = [
    "Local storage",
    "Google maps",
    "New screen 1",
    "New screen 2",
    "New screen 3",
    "New screen 4",
    "New screen 5",
    "New screen 6",
    "New screen 7",
  ];

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
      body: Center(
        child: Column(
          children: [
            Expanded(
                flex: 8,
                child: ListView.builder(
                  itemCount: myHiveData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: //Show Name of user stored in data base
                            Text("Name : ${myHiveData[index]} "),
                        subtitle: //Show Email of user stored in data base
                            Text("Description : $index"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // To edit the data stored
                            IconButton(
                                onPressed: () {
                                  if (index == 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HiveScreen()),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FavoritesPage()),
                                    );
                                  }
                                  // showForm(userData["key"]);
                                },
                                icon: const Icon(Icons.edit_note_rounded)),
                          ],
                        ),
                      ),
                    );
                  },
                )),
            Expanded(
              child: Center(
                child: FutureBuilder<Album>(
                  future: futureAlbum,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text("Rest api example.. fetch data from network"),
                          Text(snapshot.data!.title)
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(
                      child: Text("There are lot's of items in navigation")),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
