import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewAges extends StatelessWidget {
  final String baseUrl;
  final void Function(Map<String, dynamic> data) onComplete;

  const ViewAges({
    Key? key,
    required this.baseUrl,
    required this.onComplete,
  }) : super(key: key);

  Future<void> viewAges(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/stats/users/ages"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        onComplete(data);
      } else {
        onComplete({'message': "Error: ${response.statusCode}"});
      }
    } catch (e) {
      onComplete({'message': "Failed to fetch: $e"});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Card(
      elevation: 2,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 10 : 16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Click to view the oldest and youngest users.",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isMobile ? 12 : 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 20),
            ElevatedButton(
              onPressed: () => viewAges(context),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, isMobile ? 32 : 40),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
              ),
              child: Text(
                "View Ages",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}