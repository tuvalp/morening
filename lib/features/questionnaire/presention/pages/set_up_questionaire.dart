import 'package:flutter/material.dart';
import '../../domain/models/answer.dart';
import '/features/auth/presention/components/auth_button.dart';
import '../../set_up_qustion.dart';

import '../../domain/models/option.dart';
import '../../domain/models/question.dart';
import '../components/question_button.dart';

class SetUpQuestionaire extends StatefulWidget {
  SetUpQuestionaire({super.key});

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

  void _handelNext() {
    setState(() {
      answers.add(currentAnswer!);
      currentAnswer = null;

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void _handlePrevious() {
    answers.removeWhere((answer) =>
        answer.question == questions[currentQuestionIndex - 1].question);

    currentAnswer = null;

    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, top: 76.0, right: 16.0, bottom: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeader(context),
            _buildQuestion(questions[currentQuestionIndex]),
            _buildFooter()
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        for (Option option in question.options)
          QuestionButton(
            text: option.label,
            isSelected: option.label == currentAnswer?.answer,
            onPressed: () =>
                {_setAnswer(question.question, option.label, option.points)},
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
          onPressed: _handelNext,
        ),
        const SizedBox(height: 8),
        currentQuestionIndex > 0
            ? TextButton(
                onPressed: () => {_handlePrevious},
                child: Text(
                  'Go Back',
                  style: TextStyle(),
                ),
              )
            : SizedBox(
                height: 10,
              )
      ],
    );
  }
}
