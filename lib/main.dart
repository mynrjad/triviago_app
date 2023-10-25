import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/bloc/bloc_game.dart';
import 'package:untitled/screens/screen_exit.dart';
import 'package:untitled/screens/screen_game.dart';
import 'package:untitled/screens/screen_menu.dart';

void main() => runApp(
      BlocProvider(
        create: (context) => GameBloc(),
        child: const MyApp(),
      ),
    );

final GoRouter goRouter = GoRouter(
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
            return const GameScreen(); // No need to wrap it in BlocProvider now
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
  const MyApp({Key? key})
      : super(key: key); // Note: updated 'super.key' to 'key'

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
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
