import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final String label;
  final Color bgColor;
  final double fontSize;

  const TagWidget({
    super.key,
    required this.label,
    required this.bgColor,  required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
