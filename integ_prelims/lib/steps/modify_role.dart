import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/build_info_tile.dart';

class ModifyRole extends StatelessWidget{
  final String baseUrl;
  final String id;
  final Map<String, dynamic> user;
  final void Function(Map<String, dynamic> data) onComplete;

  const ModifyRole({
    Key? key,
    required this.baseUrl,
    required this.id,
    required this.user,
    required this.onComplete,
  }) : super(key: key);

  Future<void> modifyRole (BuildContext context) async {
    String role = "admin";
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/users/$id"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'role': role,
        }),
      );
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300 &&
          response.headers['content-type']?.contains('application/json') == true) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        onComplete(data);
      } else {
        onComplete({'message': "Error: ${response.statusCode}"});
      }
    } catch (e) {
      onComplete({'message': "Failed to post: $e"});
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoTile(Icons.perm_identity, 'Username', user['username'] ?? ''),
            buildInfoTile(Icons.cake, 'Age', user['age']?.toString() ?? ''),
            buildInfoTile(Icons.code, 'Code', user['code'] ?? ''),
            buildInfoTile(Icons.badge, 'Role', user['role'] ?? ''),
            SizedBox(height: isMobile ? 10 : 20),
            Text(
              "Just click Modify, I'll Handle it.",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isMobile ? 12 : 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 20),
            ElevatedButton(
              onPressed: () {
                modifyRole(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, isMobile ? 32 : 40),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
              ),
              child: Text(
                "Modify",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
