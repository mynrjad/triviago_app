class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });
}

class Quiz {
  final List<Question> questions;
  final Duration timeLimit;

  Quiz({
    required this.questions,
    required this.timeLimit,
  });
}

class QuizSession {
  final Quiz quiz;
  int currentQuestionIndex;
  int score;
  Duration remainingTime;

  QuizSession({
    required this.quiz,
    this.currentQuestionIndex = 0,
    this.score = 0,
    required this.remainingTime,
  });
}
