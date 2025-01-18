import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/question_type.dart';
import '/features/home/pages/home_view.dart';
import '/services/navigation_service.dart';
import '/utils/splash_extension.dart';
import '../../../auth/presention/auth_cubit.dart';
import '../../domain/models/answer.dart';
import '/features/auth/presention/components/auth_button.dart';
import '../../set_up_qustion.dart';

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

  void _setMultiSelectAnswer(
      Question question, String optionLabel, bool isSelected) {
    setState(() {
      if (currentAnswer == null) {
        currentAnswer = Answer(question.question, "", 0);
      }

      // Use a set to store selected options
      final selectedOptions = currentAnswer!.answer.isEmpty
          ? <String>{}
          : currentAnswer!.answer.split(', ').toSet();

      if (isSelected) {
        selectedOptions.remove(optionLabel);
      } else {
        selectedOptions.add(optionLabel);
      }

      // Update current answer with the updated selected options
      currentAnswer = Answer(question.question, selectedOptions.join(', '), 0);
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
    final _authCubit = context.read<AuthCubit>();
    final answersJson = jsonEncode(answers.map((e) => e.toJson()).toList());
    context.showSplashDialog(context);

    _authCubit.setWakeupProfile(widget.userID, answersJson).then((success) {
      if (success) {
        Navigator.of(context).pop();
        NavigationService.navigateTo(HomeView(), replace: true);
      } else {
        Navigator.of(context).pop();
      }
    });
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
            _buildHeader(),
            _buildQuestion(questions[currentQuestionIndex]),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/logo/logo.png',
          height: 70,
        ),
      ],
    );
  }

  Widget _buildQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (question.header != null)
          Text(
            question.header!,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (question.header != null) SizedBox(height: 16),
        Text(
          question.question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (question.type == QuestionType.singleSelect)
          ...question.options.map((option) => QuestionButton(
                text: option.label,
                isSelected: option.label == currentAnswer?.answer,
                onPressed: () =>
                    _setAnswer(question.question, option.label, option.points),
              )),
        if (question.type == QuestionType.multiSelect)
          ...question.options.map((option) => QuestionButton(
                text: option.label,
                isSelected:
                    currentAnswer?.answer.split(', ').contains(option.label) ??
                        false,
                onPressed: () {
                  _setMultiSelectAnswer(
                    question,
                    option.label,
                    currentAnswer?.answer.split(', ').contains(option.label) ??
                        false,
                  );
                },
              )),
        if (question.type == QuestionType.freeText) SizedBox(height: 64),
        if (question.type == QuestionType.freeText)
          TextField(
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            decoration: InputDecoration(
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.tertiary),
              contentPadding: const EdgeInsets.all(16),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              hintText: 'Type your answer...',
            ),
            onChanged: (value) => _setAnswer(question.question, value, 0),
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
