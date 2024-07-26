import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:todonode/Screen/MainHome.dart';
import 'package:todonode/constant/Urls.dart';

class Loginscreen extends StatefulWidget {
  Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    sharedPref();
  }

  void sharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  void logfunc() async {
    print('clciked');
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var object = {
        'email': emailController.text,
        'password': passwordController.text
      };

      try {
        final responce = await http.post(Uri.parse(login),
            headers: {'Content-Type': "application/json"},
            body: jsonEncode(object));
        var responce2 = jsonDecode(responce.body);
        print(' token is ${responce2['token']}');
        if (responce2['status'] == true) {
          var token = responce2['token'];
          pref.setString('token', token);
          print("token is ----------------------------->$token");

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainHome(
                  token: token,
                ),
              ));
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("login"),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder()),
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: () {
                  logfunc();
                },
                child: const Text(
                  'Log I',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ]),
      ),
    );
  }
}
