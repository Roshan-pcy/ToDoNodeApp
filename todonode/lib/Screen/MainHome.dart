import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:todonode/constant/Urls.dart';

class MainHome extends StatefulWidget {
  String token;
  MainHome({super.key, required this.token});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  String email = 'abc';
  String _id = 'abc';
  String postId = 'abc';
  List? items;
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
    email = decodedToken['email'];
    _id = decodedToken['_id'];

    print("the Id isn $_id");
    getToDodata(_id);
  }

  void getToDodata(id) async {
    try {
      final responce = await http.post(Uri.parse(getalldata),
          headers: {'Content-Type': "application/json"},
          body: jsonEncode({"userId": id}));
      var responce2 = jsonDecode(responce.body);

      if (responce2['status'] == true) {
        items = responce2['success'];
        print("data inside the list is $items");
      }
    } catch (error) {
      print("The error is $error ");
    }
    setState(() {});
  }

  void toDoCreate() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var object = {
        'userId': _id,
        'title': emailController.text,
        'dis': passwordController.text
      };

      try {
        final responce = await http.post(Uri.parse(createTodo),
            headers: {'Content-Type': "application/json"},
            body: jsonEncode(object));
        var responce2 = jsonDecode(responce.body);

        if (responce2['status'] == true) {
          emailController.clear();
          passwordController.clear();
          getToDodata(_id);
        }
      } catch (error) {
        print("The error is $error ");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: Column(children: [
          const Text("Note"),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
                hintText: 'discription', border: OutlineInputBorder()),
          ),
          MaterialButton(
            color: Colors.green,
            onPressed: () {
              toDoCreate();
            },
            child: const Text(
              'Add Note',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: items == null ? 1 : items!.length,
            itemBuilder: (context, index) {
              return items == null
                  ? Text('$_id')
                  : Padding(
                      padding: const EdgeInsets.all(1),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              flex: 2,
                              onPressed: (context) {
                                deleteTodo(items![index]['_id']);
                              },
                              backgroundColor: Color.fromARGB(255, 207, 47, 47),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: ListTile(
                              textColor: Colors.white,
                              focusColor: Colors.green,
                              title: Text(items![index]['title']),
                              subtitle: Text(items![index]['dis']),
                            ),
                          ),
                        ),
                      ),
                    );
            },
          ))
        ]),
      ),
    );
  }

  void deleteTodo(String id) async {
    try {
      final responce = await http.post(Uri.parse(deleteData),
          headers: {'Content-Type': "application/json"},
          body: jsonEncode({"id": id}));
      var responce2 = jsonDecode(responce.body);

      if (responce2['status'] == true) {
        getToDodata(_id);
      }
    } catch (error) {
      print("The error is $error ");
    }
    print("the id is $id");
  }
}
