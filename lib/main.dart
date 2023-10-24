import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/screens/screen_exit.dart';
import 'package:untitled/screens/screen_game.dart';
import 'package:untitled/screens/screen_menu.dart';

void main() => runApp(const MyApp());

final GoRouter goRouter = GoRouter(
  //Routes
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Menu();
      },
      routes: [
        GoRoute(
          path: 'game',
          builder: (BuildContext context, GoRouterState state) {
            return const GameScreen();
          },
        ),
        GoRoute(
          path: 'exit',
          builder: (BuildContext context, GoRouterState state) {
            return const ExitScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
        fontFamily: 'Inter',
        // Add other theme properties as needed
      ),
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Triviago_BG.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
