import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/build_info_tile.dart';

class ModifyRole extends StatelessWidget{
  final String baseUrl;
  final Map<String, dynamic> user;
  final void Function(Map<String, dynamic> data) onComplete;

  const ModifyRole({
    Key? key,
    required this.baseUrl,
    required this.user,
    required this.onComplete,
  }) : super(key: key);

  Future<void> modifyRole (BuildContext context) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/users/${user['id']}"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'role': "admin",
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
            buildInfoTile(Icons.badge, 'Role', 'admin'),
            SizedBox(height: isMobile ? 10 : 20),
            ElevatedButton(
              onPressed: (){
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
