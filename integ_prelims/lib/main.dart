import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widgets/floating_circle.dart';
import 'widgets/app_header.dart';
import 'steps/signup.dart';
import 'steps/login.dart';
import 'steps/login_plus_plus.dart';
import 'steps/search.dart';

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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white, 
        ),
      ),
      home: MyHomepage(),
    );
  }
}

class MyHomepage extends StatefulWidget {
  const MyHomepage({Key? key}) : super(key: key);

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage>
    with TickerProviderStateMixin {
  late final AnimationController _circle1Controller;
  late final AnimationController _circle2Controller;
  late final AnimationController _circle3Controller;
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String titleMain = "ITMC311";
  String subTitle = "Preliminary Examinations";
  String message = "Loading...";
  String id = '';
  String code = '';

  final String baseUrl = "https://prelim-exam.onrender.com";
  int currentStep = 0;
  late List<Widget Function()> stepWidgets;
  late List<String> answers;

  Future<void> fetchInitialData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        setState(() {
          message = response.body.trim();
        });
      } else {
        setState(() {
          message = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        message = "Failed to load: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _circle1Controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    _circle2Controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    _circle3Controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    fetchInitialData();

    stepWidgets = [
      () => SignupStep(
        page: 1,
        baseUrl: baseUrl,
        usernameController: _usernameController,
        passwordController: _passwordController,
        ageController: _ageController,
        onComplete: (data) {
          setState(() {
            message = data['message'] ?? '';
            currentStep = 1;
          });
        },
      ),
      () => SignupStep(
        page: 2,
        baseUrl: baseUrl,
        usernameController: _usernameController,
        passwordController: _passwordController,
        ageController: _ageController,
        onComplete: (data) {
          setState(() {
            message = data['message'] ?? '';
            id = data['id'] ?? '';
            code = data['code'] ?? '';
            currentStep = 2;
          });
        },
      ),
      () => loginWidget(
        baseUrl: baseUrl,code: code, id: id,
        usernameController: _usernameController,
        passwordController: _passwordController,
        onComplete: (data) {
          setState(() {
            message = data['message'] ?? '';
            currentStep = 3;
          });
        },
      ),
      () => loginWithAuth(
        baseUrl: baseUrl, code: code,
        username: _usernameController.text,
        password: _passwordController.text,
        age : _ageController.text,
        onComplete: (data) {
          setState(() {
            message = data['message'] ?? '';
            currentStep = 4;
          });
        },
      ),
    () => SearchOwn(
      baseUrl: baseUrl, id: id,
      onComplete:(data){
        setState((){
          message = data['message'] ?? '';
          answers= data['user'];
          // currentStep = 5;
        });
      }
      )
    ];
  }

  @override
  void dispose() {
    _circle1Controller.dispose();
    _circle2Controller.dispose();
    _circle3Controller.dispose();
    super.dispose();
  } 
  
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AppHeader(),
        automaticallyImplyLeading: false,
        toolbarHeight: isMobile ? 64 : 80,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF203198),
              Color(0xFF4a5fcf),
              Color(0xFF1ca8ec),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating circles
            Positioned.fill(
              child: Stack(
                children: [
                  FloatingCircle(
                    controller: _circle1Controller,
                    size: 120,
                    top: 0.15,
                    left: 0.60,
                    delay: 0,
                  ),
                  FloatingCircle(
                    controller: _circle2Controller,
                    size: 80,
                    bottom: 0.30,
                    right: 0.05,
                    delay: 2,
                  ),
                  FloatingCircle(
                    controller: _circle3Controller,
                    size: 60,
                    top: 0.60,
                    left: 4.00,
                    delay: 1,
                  ),
                  FloatingCircle(
                    controller: _circle1Controller,
                    size: 100,
                    top: 0.30,
                    left: 0.50,
                    delay: 3,
                  ),
                  FloatingCircle(
                    controller: _circle2Controller,
                    size: 70,
                    bottom: 0.20,
                    left: 0.55,
                    delay: 1.5.toInt(), 
                  ),
                  FloatingCircle(
                    controller: _circle3Controller,
                    size: 50,
                    top: 0.80,
                    right: 0.15,
                    delay: 2.5.toInt(),
                  ),
                ],
              ),
            ),
            Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: _leftView(isMobile),
                ),
                SizedBox(
                  width: 400,
                  child: stepWidgets[currentStep](),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _leftView (bool isMobile){
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 80,
          vertical: isMobile ? 60 : 120,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              titleMain,
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: isMobile ? 40 : 72, 
                fontWeight: FontWeight.w800,
                height: 0.9,
                color: Colors.white,
                letterSpacing: -0.03 * (isMobile ? 40 : 72),
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: Offset(0, 4),
                    blurRadius: 20,
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: isMobile ? 16 : 24,
                fontWeight: FontWeight.w600,
                height: 1.3,
                color: Colors.white.withValues(alpha: 0.95),
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: Offset(0, 2),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: isMobile ? 120 : 200,
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Text(
              message,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: isMobile ? 16 : 20,
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}