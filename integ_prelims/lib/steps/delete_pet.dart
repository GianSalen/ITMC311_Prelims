import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeletePet extends StatelessWidget {
  final String baseUrl;
  final String petId;
  final String message;
  final void Function(Map<String, dynamic> data) onComplete;

  const DeletePet({
    Key? key,
    required this.baseUrl,
    required this.petId,
    required this.message,
    required this.onComplete,
  }) : super(key: key);

  Map<String, String> extractInfo(String msg) {
    final countMatch = RegExp(r'pet_count:(\d+)').firstMatch(msg);
    final dateMatch = RegExp(r'date:([0-9/]+)').firstMatch(msg);
    return {
      'count': countMatch?.group(1) ?? '',
      'date': dateMatch?.group(1) ?? '',
    };
  }

  Future<void> deletePet(BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/pets/$petId"),
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      onComplete(data);
    } catch (e) {
      onComplete({"message": "Delete failed: $e"});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final info = extractInfo(message);
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
            if (info['count']!.isNotEmpty && info['date']!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Pet count: ${info['count']}, Date: ${info['date']}",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Text(
              "To delete your pet, simply click the button below.",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isMobile ? 12 : 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 20),
            ElevatedButton(
              onPressed: () => deletePet(context),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, isMobile ? 32 : 40),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
              ),
              child: Text(
                "Delete Pet",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}