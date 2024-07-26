import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todonode/Screen/logInScreen.dart';
import 'package:todonode/constant/Urls.dart';

class Registerscreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Registerscreen({super.key});
  void registerFun(BuildContext context) async {
    print('clciked');
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var object = {
        'email': emailController.text,
        'password': passwordController.text
      };

      try {
        final responce = await http.post(Uri.parse(register),
            headers: {'Content-Type': "application/json"},
            body: jsonEncode(object));
        var responce2 = jsonDecode(responce.body);

        if (responce2['status'] == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Loginscreen(),
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
              const Text("Registration"),
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
                  registerFun(context);
                },
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have account? ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Loginscreen(),
                            ));
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.blue),
                      ))
                ],
              )
            ]),
      ),
    );
  }
}
