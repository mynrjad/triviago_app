import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/bloc_game.dart';
import '../bloc/bloc_game_event.dart';

/// The home screen
class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();
    // You can add any initialization logic here if needed.
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo image here
              Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Triviago_logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Gap between logo and button
              // Start Game Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black.withOpacity(0.7), // Translucent feel
                  shadowColor: Colors.black,
                  elevation: 0,
                  side: const BorderSide(
                      color: Colors.white, width: 2), // 2px solid white border
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20), // Bigger button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Rounder corners
                  ),
                ),
                onPressed: () {
                  context.go('/game');
                  // Add the StartGame event trigger here.
                  context.read<GameBloc>().add(StartGame());
                },
                child: const Text(
                  'Start Game',
                  style: TextStyle(
                    color: Colors.white, // White text
                    fontSize: 24, // Bigger font size for "popping" feel
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
