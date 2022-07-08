import 'package:interviewer/models/answers/answer.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/company.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/redux/answers/state.dart';
import 'package:interviewer/redux/app/state.dart';
import 'package:interviewer/redux/companies/state.dart';
import 'package:interviewer/redux/folders/state.dart';
import 'package:interviewer/redux/questions/state.dart';
import 'package:uuid/uuid.dart';

Map<String, Question> questions = {
  // Select value
  '0126eea2-8c9e-4694-854a-5dde7e40d7f3': Question(
    id: '0126eea2-8c9e-4694-854a-5dde7e40d7f3',
    text: 'First',
    answerId: '0de352b4-bc0d-473b-8369-6b2a2655d2c4',
    folderId: 'a838c081-8239-4938-ad48-03cc741cc26a',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
  ),
  '2a131e39-b228-435d-87a8-3d2235f3f996': Question(
    id: '2a131e39-b228-435d-87a8-3d2235f3f996',
    text: 'Second',
    answerId: 'de207e5f-0b05-42c9-854c-d33a55da9254',
    folderId: 'a838c081-8239-4938-ad48-03cc741cc26a',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    note: 'Note of second question',
  ),
  '679abfd8-96fb-41bd-8811-35314d330a45': Question(
    id: '679abfd8-96fb-41bd-8811-35314d330a45',
    text: 'Використовуєте код рев\'ю? Пул реквести?',
    answerId: '7f144165-99e2-4b55-8f42-078d4f0e781c',
    folderId: 'a838c081-8239-4938-ad48-03cc741cc26a',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    note: 'Note of код рев\'ю',
  ),
  // Input number
  'b2f2b1f3-e72e-4407-81ab-d7b409240816': Question(
    id: 'b2f2b1f3-e72e-4407-81ab-d7b409240816',
    text:
        'Дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже довге питання',
    answerId: '8eaf6d59-5c87-46d3-be78-12ea3dd3b784',
    folderId: 'bdee85e5-9300-47b3-8ebb-4b394441050d',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
  ),
  '08130fcb-c273-4d35-8a1a-61bb66c55fbf': Question(
    id: '08130fcb-c273-4d35-8a1a-61bb66c55fbf',
    text: 'What is the ordinary regime in your company?',
    answerId: '5993c19b-bcc7-490e-82cf-a43fee808131',
    folderId: 'bdee85e5-9300-47b3-8ebb-4b394441050d',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
  ),
  // Input text
  '90722a10-7f73-4614-bc42-b6bad0bf113f': Question(
    id: '90722a10-7f73-4614-bc42-b6bad0bf113f',
    text: 'Скільки зарплата?',
    answerId: '024beaa5-347d-408d-89da-7225a7621d12',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
  ),
  '65d9182f-ad00-4619-905f-7337b62fafed': Question(
    id: '65d9182f-ad00-4619-905f-7337b62fafed',
    text: 'What is the salary range?',
    answerId: 'a44c936a-390c-4cfc-9b7d-edbf4eb5bb6a',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
  )
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
    isMultipleSelect: true,
  ),
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
      SelectValue(id: const Uuid().v4(), value: 'Seven', isSelected: false),
    ],
    isMultipleSelect: false,
  ),
  // Input number
  '8eaf6d59-5c87-46d3-be78-12ea3dd3b784': InputNumberAnswer(
      id: '8eaf6d59-5c87-46d3-be78-12ea3dd3b784', value: 8.25),
  '5993c19b-bcc7-490e-82cf-a43fee808131': InputNumberAnswer(
      id: '5993c19b-bcc7-490e-82cf-a43fee808131', value: null),
  // Input text
  '024beaa5-347d-408d-89da-7225a7621d12': InputTextAnswer(
      id: '024beaa5-347d-408d-89da-7225a7621d12',
      text: 'Some text in this answer'),
  'a44c936a-390c-4cfc-9b7d-edbf4eb5bb6a': InputTextAnswer(
    id: 'a44c936a-390c-4cfc-9b7d-edbf4eb5bb6a',
    text: '',
  )
};

Map<String, Folder> folders = {
  'a838c081-8239-4938-ad48-03cc741cc26a': Folder(
    id: 'a838c081-8239-4938-ad48-03cc741cc26a',
    name: 'First',
    order: 0,
  ),
  'bdee85e5-9300-47b3-8ebb-4b394441050d': Folder(
    id: 'bdee85e5-9300-47b3-8ebb-4b394441050d',
    name: 'Second',
    order: 1,
  )
};
List<String> foldersAll = [
  'a838c081-8239-4938-ad48-03cc741cc26a',
  'bdee85e5-9300-47b3-8ebb-4b394441050d',
];

Map<String, Company> companies = {
  '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7': Company(
    id: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    name: 'Template',
    isTemplate: true,
  ),
  '1a75e5cd-f24b-4ead-9976-dab429f084ea': Company(
    id: '1a75e5cd-f24b-4ead-9976-dab429f084ea',
    name: 'Company 1',
  ),
  'ac6ffd30-490a-4a26-aff7-ad00bf411c4b': Company(
    id: 'ac6ffd30-490a-4a26-aff7-ad00bf411c4b',
    name: 'Company 2',
  )
};
List<String> companiesAll = [
  '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
  '1a75e5cd-f24b-4ead-9976-dab429f084ea',
  'ac6ffd30-490a-4a26-aff7-ad00bf411c4b',
];

Map<String, List<String>> companiesQuestions = {
  '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7': [
    '0126eea2-8c9e-4694-854a-5dde7e40d7f3',
    '2a131e39-b228-435d-87a8-3d2235f3f996',
    '679abfd8-96fb-41bd-8811-35314d330a45',
    'b2f2b1f3-e72e-4407-81ab-d7b409240816',
    '08130fcb-c273-4d35-8a1a-61bb66c55fbf',
    '90722a10-7f73-4614-bc42-b6bad0bf113f',
    '65d9182f-ad00-4619-905f-7337b62fafed'
  ]
};

AppState createMock() {
  final questionsState = QuestionsState(
    byId: questions,
    all: questionsAll,
    companiesQuestions: companiesQuestions,
  );
  final answerState = AnswersState(answers);
  final foldersState = FoldersState(byId: folders, all: foldersAll);
  final companiesState = CompaniesState(
    byId: companies,
    all: companiesAll,
  );
  return AppState(
    questions: questionsState,
    answers: answerState,
    folders: foldersState,
    companies: companiesState,
  );
}
