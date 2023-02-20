import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final double size;

  const AppIcon({
    Key? key,
    required this.icon,
    required this.color,
    required this.text,
    this.size = 25.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: size,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(text, style: const TextStyle(color: Colors.black, fontSize: 16))
      ],
    );
  }
}
