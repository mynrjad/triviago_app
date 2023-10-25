import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linear_timer/linear_timer.dart'; // <- Import the linear_timer package
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

  ValueKey<int> timerKey = const ValueKey<int>(0); // Added key for LinearTimer

  Future<void> handleAnswer(
      GameBloc gameBloc, String option, GameState state) async {
    setState(() {
      isButtonDisabled = true;
    });

    // Determine the correctness of the given answer
    final correctAnswer =
        state.questions[state.currentQuestionIndex]['correctAnswer'];

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

    // Add the AnswerQuestion event with the given option
    gameBloc.add(AnswerQuestion(answer: option));

    await Future.delayed(const Duration(seconds: 2));

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

          timerKey = ValueKey<int>(state
              .currentQuestionIndex); // Reset the timer for every new question
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Triviago_BG.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // LinearTimer integration
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: LinearTimer(
                    key: timerKey, // Attach the key here
                    duration: const Duration(seconds: 10),
                    forward: false,
                    onTimerEnd: () {
                      // When the timer finishes, move to the next question
                      context.read<GameBloc>().add(NextQuestion());
                    },
                    color: Colors.blue, // Optional: Set your preferred color
                    backgroundColor: Colors
                        .white, // Optional: Set your preferred background color
                    minHeight: 5.0, // Optional: Adjust based on your preference
                  ),
                ),
                // Rest of your game UI
                Expanded(
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
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, top: 8.0),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white,
                                        ),
                                        child: Text(
                                          option,
                                          style: const TextStyle(
                                              color: Colors.black),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
