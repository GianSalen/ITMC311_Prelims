import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupStep extends StatelessWidget {
  final int page;
  final String baseUrl;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController ageController;
  final void Function(Map<String, dynamic> data) onComplete;

  const SignupStep({
    Key? key,
    required this.page,
    required this.baseUrl,
    required this.usernameController,
    required this.passwordController,
    required this.ageController,
    required this.onComplete,
  }) : super(key: key);

  Future<void> postUser(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      onComplete(data);
    } catch (e) {
      onComplete({'message': "Failed to post: $e"});
    }
  }

  Future<void> postAge(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': usernameController.text,
          'password': passwordController.text,
          'age': ageController.text,
        }),
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      onComplete(data); 
      print(data);
    } catch (e) {
      print(e);
      onComplete({'message': "Failed to post age: $e"});

    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Card(
      elevation: 2,
      color: Colors.white.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 10 : 16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person, size: isMobile ? 18 : 24),
              ),
              style: TextStyle(fontSize: isMobile ? 14 : 18),
            ),
            SizedBox(height: isMobile ? 8 : 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock, size: isMobile ? 18 : 24),
              ),
              obscureText: true,
              style: TextStyle(fontSize: isMobile ? 14 : 18),
            ),
            if (page == 2) ...[
              SizedBox(height: isMobile ? 8 : 16),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: "Age",
                  prefixIcon: Icon(Icons.cake, size: isMobile ? 18 : 24),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ],
            SizedBox(height: isMobile ? 10 : 20),
            ElevatedButton(
              onPressed: () {
                if (page == 1) {
                  postUser(context);
                } else {
                  postAge(context);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, isMobile ? 32 : 40),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}