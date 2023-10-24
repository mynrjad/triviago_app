import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The home screen
class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Triviago_BG.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.7), // Translucent feel
              shadowColor: Colors.black,
              elevation: 0,
              side: const BorderSide(color: Colors.white, width: 2), // 2px solid white border
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Bigger button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Rounder corners
              ),
            ),
            onPressed: () => context.go('/game'),
            child: const Text(
              'Start Game',
              style: TextStyle(
                color: Colors.white, // White text
                fontSize: 24, // Bigger font size for "popping" feel
              ),
            ),
          ),
        ),
      ),
    );
  }
}
