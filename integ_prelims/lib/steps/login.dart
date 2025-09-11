import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
            _buildInfoTile(Icons.vpn_key, 'Code', code),
            _buildInfoTile(Icons.perm_identity, 'ID', id),
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
                "Enter",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

    // "borrowed" from xavlog
    Widget _buildInfoTile(IconData icon, String label, String value) {
    final fontSize = 14;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(fontSize * 0.4),
            decoration: BoxDecoration(
              color: const Color(0xFF071D99).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF071D99),
              size: fontSize * 1.2,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: fontSize * 1.2,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
