import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReFetch extends StatelessWidget{
  final String baseUrl;
  final String id;
  final void Function(Map<String, dynamic> data) onComplete;

  ReFetch({
    Key? key,
    required this.baseUrl,
    required this.id,
    required this.onComplete,
  }) : super(key: key);

  Future <void> reFetch (BuildContext context) async {
    try{
      final response = await http.get(Uri.parse("$baseUrl/pets?userId=$id")).timeout(Duration(seconds: 10));
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
            ElevatedButton(
              onPressed: (){
                reFetch(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, isMobile ? 32 : 40),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
              ),
              child: Text(
                "Retry Viewing Pets",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
