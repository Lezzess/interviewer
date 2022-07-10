import 'package:flutter/material.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_number_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_input_text_answer.dart';
import 'package:interviewer/pages/my_questions/widgets/my_select_value_answer.dart';
import 'package:interviewer/states/questions_state.dart';
import 'package:interviewer/styles/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

typedef OnEdit = void Function(Question question);
typedef OnRemove = void Function(Question question);

class MyQuestion extends StatefulWidget {
  final Question question;
  final OnEdit? onEdit;
  final OnRemove? onRemove;

  const MyQuestion({
    super.key,
    required this.question,
    this.onEdit,
    this.onRemove,
  });

  @override
  State<MyQuestion> createState() => _MyQuestionState();
}

class _MyQuestionState extends State<MyQuestion> {
  bool isNoteVisible = false;
  late BehaviorSubject<String> _noteSubject;
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.question.note);
    _noteSubject = BehaviorSubject<String>.seeded(widget.question.note ?? '');
    _noteSubject.stream
        .skip(1)
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen((value) =>
            context.read<QuestionsState>().saveNote(widget.question, value));
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
        child: Column(
          children: [
            _questionHeader(context),
            Stack(
              children: [_answer(context), if (isNoteVisible) _note(context)],
            )
          ],
        ),
      ),
    );
  }

  Widget _questionHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).colorScheme.primary))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.question.text ?? '',
                  style: Theme.of(context).textTheme.questionText,
                ),
              ),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.fromLTRB(5, 13, 5, 5),
            constraints: const BoxConstraints(),
            icon: Icon(Icons.note_alt,
                color: (widget.question.note == null ||
                        widget.question.note!.isEmpty)
                    ? Theme.of(context).unselectedWidgetColor
                    : Theme.of(context).colorScheme.secondary),
            onPressed: _showNoteField,
          ),
          IconButton(
            padding: const EdgeInsets.fromLTRB(5, 13, 5, 5),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () => widget.onEdit?.call(widget.question),
          ),
          IconButton(
            padding: const EdgeInsets.fromLTRB(5, 13, 5, 5),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            onPressed: () => widget.onRemove?.call(widget.question),
          )
        ],
      ),
    );
  }

  Widget _answer(BuildContext context) {
    final answer = widget.question.answer;
    if (answer is SelectValueAnswer) {
      return MySelectValueAnswer(answer: answer);
    } else if (answer is InputNumberAnswer) {
      return _answerInputNumber(answer);
    } else if (answer is InputTextAnswer) {
      return _answerInputText(answer);
    }

    return const ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Unknown answer type'),
    );
  }

  Widget _note(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10.0),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            minLines: null,
            maxLines: null,
            expands: true,
            autofocus: true,
            onChanged: (text) => _noteSubject.add(text),
          ),
        ),
      ),
    );
  }

  Widget _answerInputNumber(InputNumberAnswer answer) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: MyInputNumberAnswer(
          answer: answer,
          debounceTime: 500,
        ),
      ),
    );
  }

  Widget _answerInputText(InputTextAnswer answer) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Align(
          alignment: Alignment.centerLeft,
          child: MyInputTextAnswer(
            answer: answer,
            debounceTime: 500,
          ),
        ));
  }

  void _showNoteField() {
    setState(() {
      isNoteVisible = !isNoteVisible;
    });
  }
}
