import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/CCS.png',
            width: isMobile ? 40 : 56,
            height: isMobile ? 40 : 56,
            fit: BoxFit.contain,
          ),
          SizedBox(width: isMobile ? 12 : 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ITMC311",
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 20 : 28,
                  color: Colors.white,
                ),
              ),
              Text(
                "Integrative Programming and Technologies 2",
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.normal,
                  fontSize: isMobile ? 12 : 16,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white, size: isMobile ? 28 : 32),
            onPressed: () {
              // TODO: menu action
            },
          ),
        ],
      ),
    );
  }
}