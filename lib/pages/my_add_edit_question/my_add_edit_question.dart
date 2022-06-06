import 'package:flutter/material.dart';
import 'package:interviewer/pages/my_add_edit_question/widgets/my_dropdown.dart';

class MyAddEditQuestion extends StatefulWidget {
  const MyAddEditQuestion({Key? key}) : super(key: key);

  @override
  State<MyAddEditQuestion> createState() => _MyAddEditQuestionState();
}

class _MyAddEditQuestionState extends State<MyAddEditQuestion> {
  String? dvalue;
  List<String> dvalues = ['One', 'Two', 'Three'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add question'),
      ),
      body: Column(
        children: [_questionInput(), _answerTypeInput(), _answerValuesInput()],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {},
      ),
    );
  }

  Widget _questionInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: TextField(
          decoration: InputDecoration(
              hintText: 'Type in a question',
              labelText: 'What to ask?',
              labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              alignLabelWithHint: true),
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    );
  }

  Widget _answerTypeInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Column(
          children: [
            MyDropdown(
                values: dvalues,
                selectedValue: dvalue,
                onValueChanged: (newValue) => setState(() {
                      dvalue = newValue;
                    }))
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }

  Widget _answerValuesInput() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: InputDecorator(
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'What are answer options?',
                labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                alignLabelWithHint: true),
            child: Text('Some text'),
          ),
        )),
      ),
    );
  }
}
