import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/answers/state.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/questions/state.dart';
import 'package:uuid/uuid.dart';

Map<String, Question> questions = {
  // Select value
  '0126eea2-8c9e-4694-854a-5dde7e40d7f3': Question(
      id: '0126eea2-8c9e-4694-854a-5dde7e40d7f3',
      text: 'First',
      answerId: '0de352b4-bc0d-473b-8369-6b2a2655d2c4'),
  '2a131e39-b228-435d-87a8-3d2235f3f996': Question(
      id: '2a131e39-b228-435d-87a8-3d2235f3f996',
      text: 'Second',
      answerId: 'de207e5f-0b05-42c9-854c-d33a55da9254'),
  '679abfd8-96fb-41bd-8811-35314d330a45': Question(
      id: '679abfd8-96fb-41bd-8811-35314d330a45',
      text: 'Використовуєте код рев\'ю? Пул реквести?',
      answerId: '7f144165-99e2-4b55-8f42-078d4f0e781c'),
  // Input number
  'b2f2b1f3-e72e-4407-81ab-d7b409240816': Question(
      id: 'b2f2b1f3-e72e-4407-81ab-d7b409240816',
      text:
          'Дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже довге питання',
      answerId: '8eaf6d59-5c87-46d3-be78-12ea3dd3b784'),
  '08130fcb-c273-4d35-8a1a-61bb66c55fbf': Question(
      id: '08130fcb-c273-4d35-8a1a-61bb66c55fbf',
      text: 'What is the ordinary regime in your company?',
      answerId: '5993c19b-bcc7-490e-82cf-a43fee808131'),
  // Input text
  '90722a10-7f73-4614-bc42-b6bad0bf113f': Question(
      id: '90722a10-7f73-4614-bc42-b6bad0bf113f',
      text: 'Скільки зарплата?',
      answerId: '024beaa5-347d-408d-89da-7225a7621d12'),
  '65d9182f-ad00-4619-905f-7337b62fafed': Question(
      id: '65d9182f-ad00-4619-905f-7337b62fafed',
      text: 'What is the salary range?',
      answerId: 'a44c936a-390c-4cfc-9b7d-edbf4eb5bb6a')
};
List<String> questionsAll = [
  // Select value
  '0126eea2-8c9e-4694-854a-5dde7e40d7f3',
  '2a131e39-b228-435d-87a8-3d2235f3f996',
  '679abfd8-96fb-41bd-8811-35314d330a45',
  // Input number
  'b2f2b1f3-e72e-4407-81ab-d7b409240816',
  '08130fcb-c273-4d35-8a1a-61bb66c55fbf',
  // Input text
  '90722a10-7f73-4614-bc42-b6bad0bf113f',
  '65d9182f-ad00-4619-905f-7337b62fafed'
];

Map<String, Answer> answers = {
  // Select value
  '0de352b4-bc0d-473b-8369-6b2a2655d2c4': SelectValueAnswer(
      id: '0de352b4-bc0d-473b-8369-6b2a2655d2c4',
      values: [
        SelectValue(id: const Uuid().v4(), value: 'One', isSelected: false),
        SelectValue(id: const Uuid().v4(), value: 'Two', isSelected: false),
        SelectValue(id: const Uuid().v4(), value: 'Three', isSelected: false)
      ],
      isMultipleSelect: true),
  'de207e5f-0b05-42c9-854c-d33a55da9254': SelectValueAnswer(
      id: 'de207e5f-0b05-42c9-854c-d33a55da9254',
      values: [
        SelectValue(id: const Uuid().v4(), value: 'Four', isSelected: false)
      ],
      isMultipleSelect: true),
  '7f144165-99e2-4b55-8f42-078d4f0e781c': SelectValueAnswer(
      id: '7f144165-99e2-4b55-8f42-078d4f0e781c',
      values: [
        SelectValue(id: const Uuid().v4(), value: 'Five', isSelected: false),
        SelectValue(id: const Uuid().v4(), value: 'Six', isSelected: false),
        SelectValue(id: const Uuid().v4(), value: 'Seven', isSelected: false)
      ],
      isMultipleSelect: false),
  // Input number
  '8eaf6d59-5c87-46d3-be78-12ea3dd3b784': InputNumberAnswer(
      id: '8eaf6d59-5c87-46d3-be78-12ea3dd3b784', value: 8.25),
  '5993c19b-bcc7-490e-82cf-a43fee808131': InputNumberAnswer(
      id: '5993c19b-bcc7-490e-82cf-a43fee808131', value: null),
  // Input text
  '024beaa5-347d-408d-89da-7225a7621d12': InputTextAnswer(
      id: '024beaa5-347d-408d-89da-7225a7621d12',
      text: 'Some text in this answer'),
  'a44c936a-390c-4cfc-9b7d-edbf4eb5bb6a':
      InputTextAnswer(id: 'a44c936a-390c-4cfc-9b7d-edbf4eb5bb6a', text: '')
};

AppState createMock() {
  final questionsState = QuestionState(byId: questions, all: questionsAll);
  final inputNumberAnswersState = AnswersState(answers);
  return AppState(questions: questionsState, answers: inputNumberAnswersState);
}
