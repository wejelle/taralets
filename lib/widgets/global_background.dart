import 'package:flutter/material.dart';

class GlobalBackground extends StatelessWidget {
  final Widget child;
  const GlobalBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Faint Gradient (Hot Pink to Peach to Orange)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF0F5), // Faint Hot Pink
                Color(0xFFFFF5E6), // Faint Peach
                Color(0xFFFFF0E6), // Faint Orange
              ],
            ),
          ),
        ),
        // Circles/Bubbles Background
        Positioned(
            top: -50,
            right: -30,
            child: CircleAvatar(
                radius: 130,
                backgroundColor: const Color(0xFFFFB6C1).withOpacity(0.15))),
        Positioned(
            bottom: 100,
            left: -60,
            child: CircleAvatar(
                radius: 110,
                backgroundColor: const Color(0xFFFFDAB9).withOpacity(0.2))),
        Positioned(
            top: 300,
            left: -40,
            child: CircleAvatar(
                radius: 80,
                backgroundColor: const Color(0xFFFFA07A).withOpacity(0.15))),
        // Main Content
        child,
      ],
    );
  }
}
