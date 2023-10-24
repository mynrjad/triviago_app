abstract class GameEvent {}

class StartGame extends GameEvent {}

class NextQuestion extends GameEvent {}

class AnswerQuestion extends GameEvent {
  final String answer;
  AnswerQuestion(this.answer);
}
