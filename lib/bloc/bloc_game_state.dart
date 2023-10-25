import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  final int currentQuestionIndex;
  final List<Map<String, dynamic>> questions;
  final int score; // <-- Add this line

  const GameState(
      {required this.currentQuestionIndex,
      required this.questions,
      this.score = 0}); // <-- Initialize to 0

  @override
  List<Object?> get props =>
      [currentQuestionIndex, questions, score]; // <-- Add score here
}

class GameInitial extends GameState {
  GameInitial() : super(currentQuestionIndex: 0, questions: []);
}

class GameLoaded extends GameState {
  const GameLoaded(
      int currentQuestionIndex, List<Map<String, dynamic>> questions, int score)
      : super(currentQuestionIndex: currentQuestionIndex, questions: questions);
}

class CorrectAnswer extends GameState {
  const CorrectAnswer(
      int currentQuestionIndex, List<Map<String, dynamic>> questions)
      : super(currentQuestionIndex: currentQuestionIndex, questions: questions);
}

class IncorrectAnswer extends GameState {
  const IncorrectAnswer(
      int currentQuestionIndex, List<Map<String, dynamic>> questions)
      : super(currentQuestionIndex: currentQuestionIndex, questions: questions);
}

class GameOver extends GameState {
  @override
  final int score;

  GameOver({required this.score})
      : super(currentQuestionIndex: 0, questions: []);

  @override
  List<Object?> get props => [currentQuestionIndex, questions, score];
}
