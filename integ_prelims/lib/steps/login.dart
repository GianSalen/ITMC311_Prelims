import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/build_info_tile.dart';

class loginWidget extends StatelessWidget{
  final String baseUrl;
  final String code;
  final String id;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final void Function(Map<String, dynamic> data) onComplete;

  const loginWidget({
    Key? key,
    required this.baseUrl,
    required this.code,
    required this.id,
    required this.usernameController,
    required this.passwordController,
    required this.onComplete,
  }) : super(key: key);

  Future<void> login (BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
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

  @override
  Widget build (BuildContext context) {
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
            buildInfoTile(Icons.vpn_key, 'Code', code),
            buildInfoTile(Icons.perm_identity, 'ID', id),
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
            SizedBox(height: isMobile ? 10 : 20),
            ElevatedButton(
              onPressed: (){
                login(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, isMobile ? 32 : 40),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
              ),
              child: Text(
                "login",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
