import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewPet2 extends StatelessWidget{
  final String baseUrl;
  final List<Map<String,dynamic>> pets;
  final void Function(Map<String, dynamic> data) onComplete;

  ViewPet2({
    Key? key,
    required this.baseUrl,
    required this.pets,
    required this.onComplete,
  }) : super(key: key);

  Future <void> viewPet1 (BuildContext context) async {
    try{
      final response = await http.get(Uri.parse("$baseUrl/pets")).timeout(Duration(seconds: 10));
      final data = json.decode(response.body) as Map<String, dynamic>;
      onComplete(data);
    }
    catch(e){
      onComplete ({"message" : "Fetch Failed: $e"});
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
            Text("My pets:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            if (pets != null && pets!.isNotEmpty)
            ...pets!.take(5).map((pet) => Card(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ID: ${pet['_id'] ?? 'N/A'}"),
                    Text("Owner: ${pet['owner'] ?? 'N/A'}"),
                    Text("Name: ${pet['name'] ?? 'N/A'}"),
                    Text("Type: ${pet['type'] ?? 'N/A'}"),
                    Text("__v: ${pet['__v'] ?? 'N/A'}"),
                  ],
                ),
              ),
            ))
            
            else
              Text("No pets found"),
            SizedBox(height: isMobile ? 10 : 20),
            ElevatedButton(
              onPressed: (){
                viewPet1(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, isMobile ? 32 : 40),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
              ),
              child: Text(
                "View All Pets",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
