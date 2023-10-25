import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data_loader.dart';
import 'bloc_game_event.dart';
import 'bloc_game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  late List<Map<String, dynamic>> allQuestions;
  late List<Map<String, dynamic>> selectedQuestions;
  int currentQuestionIndex = 0;
  int score = 0;

  GameBloc() : super(GameInitial()) {
    on<StartGame>((event, emit) async {
      try {
        allQuestions = await loadTriviaQuestions();
        allQuestions.shuffle(); // Shuffle questions
        selectedQuestions = allQuestions.take(10).toList(); // Take the first 10
        currentQuestionIndex = 0;
        score = 0; // Reset score
        emit(GameLoaded(currentQuestionIndex, selectedQuestions, score));
      } catch (e) {
        if (kDebugMode) {
          print("Error loading questions: $e");
        }
      }
    });

    on<NextQuestion>((event, emit) {
      if (currentQuestionIndex < selectedQuestions.length - 1) {
        currentQuestionIndex++;
        emit(GameLoaded(currentQuestionIndex, selectedQuestions, score));
      } else {
        emit(GameOver(score: score));
      }
    });

    on<AnswerQuestion>((event, emit) {
      if (selectedQuestions[currentQuestionIndex]['correctAnswer'] ==
          event.answer) {
        score++; // Increment score
        emit(CorrectAnswer(currentQuestionIndex, selectedQuestions));
      } else {
        emit(IncorrectAnswer(currentQuestionIndex, selectedQuestions));
      }

      Future.delayed(const Duration(seconds: 2), () {
        add(NextQuestion());
      });
    });
  }
}
