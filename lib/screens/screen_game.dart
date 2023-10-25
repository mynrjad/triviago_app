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
  bool isButtonDisabled = false;
  String lastKnownQuestion = '';
  List<String> lastKnownOptions = [];

  Future<void> handleAnswer(
      GameBloc gameBloc, String option, GameState state) async {
    setState(() {
      isButtonDisabled = true;
    });

    final correctAnswer =
        state.questions[state.currentQuestionIndex]['correctAnswer'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(option == correctAnswer ? 'Correct!' : 'Wrong!'),
        backgroundColor: option == correctAnswer ? Colors.green : Colors.red,
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    gameBloc.add(NextQuestion());

    setState(() {
      isButtonDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameOver) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Game Over'),
              content: Text('Your Score is ${state.score}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Navigate back to the main menu
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GameLoaded) {
          lastKnownQuestion =
              state.questions[state.currentQuestionIndex]['question'];
          lastKnownOptions = List<String>.from(
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
                      lastKnownQuestion,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    ...lastKnownOptions
                        .map(
                          (option) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: isButtonDisabled
                                    ? null
                                    : () async {
                                        await handleAnswer(
                                            context.read<GameBloc>(),
                                            option,
                                            state);
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
