import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPet extends StatelessWidget{
  final String baseUrl;
  final String id;
  final void Function(Map<String, dynamic> data) onComplete;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  AddPet({
    Key? key,
    required this.baseUrl,
    required this.id,
    required this.onComplete,
  }) : super(key: key);

  Future<void> addPet (BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/pets/new"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': nameController.text,
          'type': typeController.text,
          'ownerId': id,
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
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.person, size: isMobile ? 18 : 24),
              ),
              style: TextStyle(fontSize: isMobile ? 14 : 18),
            ),
            SizedBox(height: isMobile ? 8 : 16),
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                labelText: "Type",
                prefixIcon: Icon(Icons.lock, size: isMobile ? 18 : 24),
              ),
              style: TextStyle(fontSize: isMobile ? 14 : 18),
            ),
            SizedBox(height: isMobile ? 10 : 20),
            ElevatedButton(
              onPressed: (){
                addPet(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, isMobile ? 32 : 40),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
              ),
              child: Text(
                "Add Pet",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
