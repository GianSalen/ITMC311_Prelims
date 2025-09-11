import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewPet4 extends StatelessWidget{
  final String baseUrl;
  final List<Map<String,dynamic>> pets;
  final void Function(Map<String, dynamic> data) onComplete;

  ViewPet4({
    Key? key,
    required this.baseUrl,
    required this.pets,
    required this.onComplete,
  }) : super(key: key);

  Future <void> viewPet1 (BuildContext context) async {
    try{
      final response = await http.get(Uri.parse("$baseUrl/stats/pets/count")).timeout(Duration(seconds: 10));
      final data = json.decode(response.body) as Map<String, dynamic>;
      onComplete(data);
    }
    catch(e){
      onComplete ({"message" : "Fetch Failed: $e"});
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
            Text(
              "My pets:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              constraints: BoxConstraints(
                maxHeight: isMobile ? 250 : 400,
              ),
              child: pets.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: pets.length > 10 ? 10 : pets.length,
                      itemBuilder: (context, index) {
                        final pet = pets[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                          elevation: 1,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name: ${pet['name'] ?? 'N/A'}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text("Type: ${pet['type'] ?? 'N/A'}"),
                                Text("Owner: ${pet['owner']?['username'] ?? 'N/A'}"),
                                Text("ID: ${pet['_id'] ?? 'N/A'}"),
                                Text("__v: ${pet['__v'] ?? 'N/A'}"),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: Text("No pets found")),
            ),
            SizedBox(height: isMobile ? 10 : 20),
            ElevatedButton(
              onPressed: () {
                viewPet1(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, isMobile ? 32 : 40),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
              ),
              child: Text(
                "See Pets Stats",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
