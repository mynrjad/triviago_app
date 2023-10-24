import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data_loader.dart';
import 'bloc_game_event.dart';
import 'bloc_game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  late List<Map<String, dynamic>> questions;
  int currentQuestionIndex = 0;
  int score = 0;

  GameBloc() : super(GameInitial()) {
    if (kDebugMode) {
      print("GameBloc initialized");
    }
    on<StartGame>((event, emit) async {
      try {
        questions = await loadTriviaQuestions();
        if (kDebugMode) {
          print("Questions loaded: $questions");
        }
        currentQuestionIndex = 0;
        emit(GameLoaded(currentQuestionIndex, questions));
        if (kDebugMode) {
          print("Emitting GameLoaded state");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error loading questions: $e");
        }
        // Optionally, emit an error state
      }
    });

    on<NextQuestion>((event, emit) {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        emit(GameLoaded(currentQuestionIndex, questions));
      } else {
        emit(GameOver(score: score));
      }
    });

    on<AnswerQuestion>((event, emit) {
      if (questions[currentQuestionIndex]['correctAnswer'] == event.answer) {
        score++; // <-- Increment the score here
        emit(CorrectAnswer(currentQuestionIndex, questions));
      } else {
        emit(IncorrectAnswer(currentQuestionIndex, questions));
      }

      // Proceed to next question after a small delay
      Future.delayed(const Duration(seconds: 2), () {
        add(NextQuestion());
      });
    });
  }
}
