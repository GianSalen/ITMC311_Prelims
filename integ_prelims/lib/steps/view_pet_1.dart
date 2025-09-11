import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/build_info_tile.dart';

class ViewPet1 extends StatelessWidget{
  final String baseUrl;
  final String id;
  final String petId;
  final void Function(Map<String, dynamic> data) onComplete;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  ViewPet1({
    Key? key,
    required this.baseUrl,
    required this.id,
    required this.petId,
    required this.onComplete,
  }) : super(key: key);

  Future <void> viewPet1 (BuildContext context) async {
    try{
      final response = await http.get(Uri.parse("$baseUrl/users/$id/pets")).timeout(Duration(seconds: 10));
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
            buildInfoTile(Icons.perm_identity, 'Pet ID', petId),
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
                "View my pets",
                style: TextStyle(fontSize: isMobile ? 14 : 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
