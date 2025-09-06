import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'ITMC311 Prelims'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String initialText = "Loading...";
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _updateUsernameController = TextEditingController();
  
  Map<String, dynamic>? postResponse;
  Map<String, dynamic>? getResponse;
  String? updateMessage;
  List<dynamic>? allUsers;
  String? userCode;
  String? userId;
  final String baseUrl = "https://prelim-exam.onrender.com/";
  
  bool showInitial = true;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        setState(() {
          initialText = response.body.trim();
        });
      } else {
        setState(() {
          initialText = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        initialText = "Failed to load: $e";
      });
    }
  }

  Future<void> postUser() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          postResponse = data;
          userCode = data['code']?.toString();
          // showInitial = false;
          // showPost = true;
        });
      }
    } catch (e) {
      setState(() {
        postResponse = {'message': 'Failed to post: $e'};
        // showInitial = false;
        // showPost = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              if (showInitial) _buildInitialView(),
              // if (showPost) _buildPostView(),
              // if (showGet) _buildGetView(),
              // if (showUpdate) _buildUpdateView(),
              // if (showAllUsers) _buildAllUsersView(),
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildInitialView() {
    return Column(
      children: [
        Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              initialText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.indigo[900],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: "Username",
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: postUser,
          child: Text("Enter"),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

}
