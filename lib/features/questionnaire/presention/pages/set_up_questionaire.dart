import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:morening_2/features/home/pages/home_view.dart';
import 'package:morening_2/services/api_service.dart';
import 'package:morening_2/services/navigation_service.dart';
import '../../domain/models/answer.dart';
import '/features/auth/presention/components/auth_button.dart';
import '../../set_up_qustion.dart';

import '../../domain/models/option.dart';
import '../../domain/models/question.dart';
import '../components/question_button.dart';

class SetUpQuestionaire extends StatefulWidget {
  final String userID;
  const SetUpQuestionaire({required this.userID, super.key});

  @override
  State<SetUpQuestionaire> createState() => _SetUpQuestionaireState();
}

class _SetUpQuestionaireState extends State<SetUpQuestionaire> {
  int currentQuestionIndex = 0;
  List<Answer> answers = [];
  Answer? currentAnswer;

  void _setAnswer(String question, String answer, int points) {
    setState(() {
      currentAnswer = Answer(question, answer, points);
    });
  }

  void _handleNext() {
    if (currentAnswer != null) {
      setState(() {
        answers.add(currentAnswer!);
        currentAnswer = null;

        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
        } else {
          _handleDone();
        }
      });
    }
  }

  void _handleDone() {
    final answersJson = jsonEncode(answers.map((e) => e.toJson()).toList());

    print(answersJson);

    ApiService().post("update_wake_up_profile", {
      "user_id": widget.userID,
      "wake_up_profile": answersJson,
    });

    NavigationService.navigateTo(HomeView(), replace: true);
  }

  void _handlePrevious() {
    if (currentQuestionIndex > 0) {
      setState(() {
        answers.removeWhere((answer) =>
            answer.question == questions[currentQuestionIndex - 1].question);
        currentAnswer = null;
        currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16, top: 76, bottom: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeader(context),
            _buildQuestion(questions[currentQuestionIndex]),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          'Morning',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion(Question question) {
    return Column(
      children: [
        Text(
          question.question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        for (Option option in question.options)
          QuestionButton(
            text: option.label,
            isSelected: option.label == currentAnswer?.answer,
            onPressed: () =>
                _setAnswer(question.question, option.label, option.points),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AuthButton(
          disabled: currentAnswer == null,
          text:
              currentQuestionIndex < questions.length - 1 ? 'Continue' : 'Done',
          onPressed: _handleNext,
        ),
        const SizedBox(height: 8),
        currentQuestionIndex > 0
            ? TextButton(
                onPressed: _handlePrevious,
                child: const Text(
                  'Go Back',
                ),
              )
            : const SizedBox(height: 10),
      ],
    );
  }
}
