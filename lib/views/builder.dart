// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<Post> fetchPost() async {
//   final response = await http.get('http://127.0.0.1:8000/posts/?format=json');

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Post.fromJson(json.decode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load post');
//   }
// }

// class Post {
//   final int count;
//   final String next;
//   final String previous;
//   final List<Result> posts;

//   Post({this.count, this.next, this.previous, this.posts});

//   factory Post.fromJson(Map<String, dynamic> json) {
//     var list = json['results'] as List;
//     List<Result> resultsList = list.map((i) => Result.fromJson(i)).toList();

//     return Post(
//       count: json['count'],
//       next: json['next'],
//       previous: json['previous'],
//       posts: resultsList,
//     );
//   }
// }

// class Result {
//   final int id;
//   final String title;
//   final String content;
//   final String author;

//   Result({this.id, this.title, this.content, this.author});

//   factory Result.fromJson(Map<String, dynamic> json) {
//     return Result(
//       id: json['id'],
//       title: json['title'],
//       content: json['content'],
//       author: json['author'],
//     );
//   }
// }

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   MyApp({Key key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   Future<Post> futurePost;

//   @override
//   void initState() {
//     super.initState();
//     futurePost = fetchPost();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Blog',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Blog'),
//         ),
//         body: Center(
//           child: FutureBuilder<Post>(
//             future: futurePost,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 List<Post> posts = List<Post>();
//                 for (int i = 0; i < snapshot.data.count - 1; i++) {
//                   posts.add(
//                     Post(
//                       posts: [
//                         Result(
//                           id: snapshot.data.posts[i].id,
//                           title: snapshot.data.posts[i].title,
//                           content: snapshot.data.posts[i].content,
//                           author: snapshot.data.posts[i].author,
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//                 return ListView(
//                   children:
//                       posts.map((post) => postTemplate(post.posts[0])).toList(),
//                 );
//               } else if (snapshot.hasError) {
//                 return Text("${snapshot.error}");
//               }

//               // By default, show a loading spinner.
//               return CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget postTemplate(post) {
//   return Card(
//     margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
//     elevation: 4.0,
//     child: Padding(
//       padding: EdgeInsets.all(12.0),
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             // Text(post.id.toString()),
//             Text(
//               post.title,
//               style: TextStyle(
//                 fontSize: 30.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               post.content,
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w200,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(
//               height: 10.0,
//             ),
//             Text(
//               'Posted by ' + post.author,
//               style: TextStyle(
//                 fontSize: 15.0,
//               ),
//             ),
//           ]),
//     ),
//   );
// }