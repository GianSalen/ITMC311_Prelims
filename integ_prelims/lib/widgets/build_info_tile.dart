import "package:flutter/material.dart";

// "borrowed" from xavlog
Widget buildInfoTile(IconData icon, String label, String value) {
final fontSize = 14;

return Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Row(
    children: [
      Container(
        padding: EdgeInsets.all(fontSize * 0.4),
        decoration: BoxDecoration(
          color: const Color(0xFF071D99).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF071D99),
          size: fontSize * 1.2,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: fontSize * 1.2,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
}