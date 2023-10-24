import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc_game.dart';
import '../bloc/bloc_game_event.dart';
import '../bloc/bloc_game_state.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        String question = '';
        List<String> options = [];

        if (state is GameLoaded) {
          question = state.questions[state.currentQuestionIndex]['question'];
          options = List<String>.from(
              state.questions[state.currentQuestionIndex]['options'] ?? []);
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Triviago_BG.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      question,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    ...options
                        .map(
                          (option) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  // Make it asynchronous
                                  final correctAnswer = state
                                          .questions[state.currentQuestionIndex]
                                      ['correctAnswer'];

                                  if (option == correctAnswer) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Correct!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Wrong!'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }

                                  // Add the delay here
                                  await Future.delayed(
                                      const Duration(seconds: 2));

                                  // After the delay, move on to the next question
                                  context.read<GameBloc>().add(NextQuestion());
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    option,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
