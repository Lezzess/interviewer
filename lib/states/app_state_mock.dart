import 'package:interviewer/db/db.dart';
import 'package:interviewer/models/answers/input_number_answer.dart';
import 'package:interviewer/models/answers/input_text_answer.dart';
import 'package:interviewer/models/answers/select_value_answer.dart';
import 'package:interviewer/models/company.dart';
import 'package:interviewer/models/folder.dart';
import 'package:interviewer/models/question.dart';
import 'package:interviewer/states/app_state.dart';
import 'package:uuid/uuid.dart';

import 'package:interviewer/repositories/companies.dart' as companies;
import 'package:interviewer/repositories/folders.dart' as folders;
import 'package:interviewer/repositories/questions.dart' as questions;

Future seedData() async {
  await Db.transaction((txn) async {
    await questions.clear(txn);
    await folders.clear(txn);
    await companies.clear(txn);

    for (final company in pcompanies) {
      await companies.add(txn, company);
    }

    for (final folder in pfolders) {
      await folders.add(txn, folder);
    }

    for (final question in pquestions) {
      await questions.add(txn, question);
    }
  });
}

List<Question> pquestions = [
  Question(
    id: '0126eea2-8c9e-4694-854a-5dde7e40d7f3',
    text: 'First',
    folderId: 'a838c081-8239-4938-ad48-03cc741cc26a',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    answer: SelectValueAnswer(
      id: '0de352b4-bc0d-473b-8369-6b2a2655d2c4',
      values: [
        SelectValue(id: const Uuid().v4(), value: 'One', isSelected: false),
        SelectValue(id: const Uuid().v4(), value: 'Two', isSelected: false),
        SelectValue(id: const Uuid().v4(), value: 'Three', isSelected: false),
      ],
      isMultiselect: true,
      questionId: '0126eea2-8c9e-4694-854a-5dde7e40d7f3',
    ),
  ),
  Question(
    id: '2a131e39-b228-435d-87a8-3d2235f3f996',
    text: 'Second',
    folderId: 'a838c081-8239-4938-ad48-03cc741cc26a',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    note: 'Note of second question',
    answer: SelectValueAnswer(
      id: 'de207e5f-0b05-42c9-854c-d33a55da9254',
      values: [
        SelectValue(id: const Uuid().v4(), value: 'Four', isSelected: false)
      ],
      isMultiselect: true,
      questionId: '2a131e39-b228-435d-87a8-3d2235f3f996',
    ),
  ),
  Question(
    id: '679abfd8-96fb-41bd-8811-35314d330a45',
    text: 'Використовуєте код рев\'ю? Пул реквести?',
    folderId: 'a838c081-8239-4938-ad48-03cc741cc26a',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    note: 'Note of код рев\'ю',
    answer: SelectValueAnswer(
      id: '7f144165-99e2-4b55-8f42-078d4f0e781c',
      values: [
        SelectValue(id: const Uuid().v4(), value: 'Five', isSelected: false),
        SelectValue(id: const Uuid().v4(), value: 'Six', isSelected: false),
        SelectValue(id: const Uuid().v4(), value: 'Seven', isSelected: false),
      ],
      isMultiselect: false,
      questionId: '679abfd8-96fb-41bd-8811-35314d330a45',
    ),
  ),
  Question(
    id: 'b2f2b1f3-e72e-4407-81ab-d7b409240816',
    text:
        'Дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже дуже довге питання',
    folderId: 'bdee85e5-9300-47b3-8ebb-4b394441050d',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    answer: InputNumberAnswer(
      id: '8eaf6d59-5c87-46d3-be78-12ea3dd3b784',
      value: 8.25,
      questionId: 'b2f2b1f3-e72e-4407-81ab-d7b409240816',
    ),
  ),
  Question(
    id: '08130fcb-c273-4d35-8a1a-61bb66c55fbf',
    text: 'What is the ordinary regime in your company?',
    folderId: 'bdee85e5-9300-47b3-8ebb-4b394441050d',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    answer: InputNumberAnswer(
      id: '5993c19b-bcc7-490e-82cf-a43fee808131',
      value: null,
      questionId: '08130fcb-c273-4d35-8a1a-61bb66c55fbf',
    ),
  ),
  Question(
    id: '90722a10-7f73-4614-bc42-b6bad0bf113f',
    text: 'Скільки зарплата?',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    answer: InputTextAnswer(
      id: '024beaa5-347d-408d-89da-7225a7621d12',
      text: 'Some text in this answer',
      questionId: '90722a10-7f73-4614-bc42-b6bad0bf113f',
    ),
  ),
  Question(
    id: '65d9182f-ad00-4619-905f-7337b62fafed',
    text: 'What is the salary range?',
    companyId: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    answer: InputTextAnswer(
      id: 'a44c936a-390c-4cfc-9b7d-edbf4eb5bb6a',
      text: '',
      questionId: '65d9182f-ad00-4619-905f-7337b62fafed',
    ),
  )
];

List<Folder> pfolders = [
  Folder(
    id: 'a838c081-8239-4938-ad48-03cc741cc26a',
    name: 'First',
    order: 0,
  ),
  Folder(
    id: 'bdee85e5-9300-47b3-8ebb-4b394441050d',
    name: 'Second',
    order: 1,
  ),
];

List<Company> pcompanies = [
  Company(
    id: '8f4fc979-f878-4d2b-aa7b-a3ac6b711ad7',
    name: 'Template',
    isTemplate: true,
  ),
  Company(
    id: '1a75e5cd-f24b-4ead-9976-dab429f084ea',
    name: 'Company 1',
  ),
  Company(
    id: 'ac6ffd30-490a-4a26-aff7-ad00bf411c4b',
    name: 'Company 2',
  ),
];

AppState createMock() {
  return AppState(
    companies: pcompanies,
    folders: pfolders,
    questions: pquestions,
  );
}
