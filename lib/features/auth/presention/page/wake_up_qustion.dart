import 'dart:convert';

import 'package:flutter/material.dart';

class Option {
  final String label;
  final int points;

  Option(this.label, this.points);
}

class Answer {
  final String question;
  final String answer;
  final int points;

  Answer(this.question, this.answer, this.points);

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'points': points,
    };
  }
}

class WakeUpQuestionScreen extends StatefulWidget {
  final String id;
  final String email;
  final String name;
  final String password;

  const WakeUpQuestionScreen({
    super.key,
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  State<WakeUpQuestionScreen> createState() => _WakeUpQuestionScreenState();
}

class _WakeUpQuestionScreenState extends State<WakeUpQuestionScreen> {
  int currentQuestionIndex = 0;
  Answer? currentAnswer;
  List<Answer> answers = [];

  void _handleAnswer(String question, String answer, int points) {
    setState(() {
      currentAnswer = Answer(question, answer, points);

      answers.add(currentAnswer!);
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        final answersJson = jsonEncode(answers.map((e) => e.toJson()).toList());

        // context.read<AuthCubit>().registerUser(
        //     widget.id, widget.email, widget.name, widget.password, answersJson);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 124),
          _buildSection(context, questions[currentQuestionIndex]),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, Question question) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildQuestion(context, question.question),
        const SizedBox(height: 16),
        for (Option option in question.options)
          _buildAnswerButtons(
              context,
              option.label,
              () => _handleAnswer(
                  question.question, option.label, option.points)),
      ],
    );
  }

  Widget _buildQuestion(BuildContext context, String question) {
    return Text(
      question,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAnswerButtons(
      BuildContext context, String text, void Function() onPressed) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onPressed(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).colorScheme.surface),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
