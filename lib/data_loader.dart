import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> loadTriviaQuestions() async {
  final String jsonString = await rootBundle.loadString('assets/trivia_questions.json');
  final List<dynamic> jsonData = jsonDecode(jsonString);
  return jsonData.cast<Map<String, dynamic>>();
}
