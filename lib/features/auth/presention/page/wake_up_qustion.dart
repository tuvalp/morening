import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/app.dart';

import '../../../../services/navigation_service.dart';
import '../auth_cubit.dart';
import '../auth_state.dart';

class Question {
  final String question;
  final List<dynamic> options;

  Question(this.question, this.options);
}

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
  List<Answer> answers = [];

  List<Question> questions = [
    Question(
      "בן כמבה אתה?",
      [
        Option("מתחת ל18", 20),
        Option("19-29", 30),
        Option("30-39", 40),
        Option("40-49", 30),
        Option("מעל 50", 20),
      ],
    ),
    Question("כמה שעות שינה אתה ישן בלילה בממוצע?", [
      Option("פחות מ-5", 10),
      Option("5-6", 20),
      Option("7-8", 30),
      Option("יותר מ-8", 40),
    ]),
    Question("כמה זמן לוקח לך להתעורר בבוקר?", [
      Option("פחות מ-5 דקות", 40),
      Option("5-15 דקות", 30),
      Option("15-30 דקות", 20),
      Option("יותר מ-30 דקות", 10),
    ]),
    Question("איך אתה מרגיש בבוקר?", [
      Option("רענן ומלא אנרגיה", 40),
      Option("עייף אך מוכן לעבוד", 30),
      Option("עייף מאוד", 20),
      Option("עייף ומתוסכל", 10),
    ]),
  ];

  void _handleAnswer(String question, String answer, int points) {
    setState(() {
      answers.add(Answer(question, answer, points));

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        final answersJson = jsonEncode(answers.map((e) => e.toJson()).toList());

        context.read<AuthCubit>().registerUser(
            widget.id, widget.email, widget.name, widget.password, answersJson);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      if (state is AuthLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is Authenticated) {
        NavigationService.navigateTo(
          const AppView(),
          replace: true,
        );
      }
      return Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 62),
                  _buildHeader(context),
                  const SizedBox(height: 124),
                  _buildSection(context, questions[currentQuestionIndex]),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'MoreNing',
          style: TextStyle(
            fontSize: 54,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Text(
          'Welcome to MoreNing',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, Question question) {
    return Column(
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
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).colorScheme.onSurfaceVariant),
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
