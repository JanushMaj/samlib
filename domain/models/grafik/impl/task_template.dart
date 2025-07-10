/// Szablony „typowych” zadań do szybkiego wypełniania formularza.
///
///  ► **label** – napis na przycisku
///  ► pozostałe pola – wartości, które mają trafić do TaskElement
///
import '../enums.dart';

class TaskTemplate {
  final String label;
  final GrafikTaskType taskType;
  final GrafikStatus status;
  final String orderId;
  final List<String> carIds;
  final int startHour;
  final int endHour;
  final String additionalInfo;

  const TaskTemplate({
    required this.label,
    required this.taskType,
    required this.status,
    required this.orderId,
    required this.carIds,
    required this.startHour,
    required this.endHour,
    required this.additionalInfo,
  });
}

/// ––––– Twoje dwa przykłady –––––
const kTaskTemplates = <TaskTemplate>[
  TaskTemplate(
    label: 'SZADO',
    taskType: GrafikTaskType.Inne,
    status: GrafikStatus.Realizacja,
    orderId: '0001',
    carIds: [],
    startHour: 7,
    endHour: 15,
    additionalInfo: 'Hala',
  ),
  TaskTemplate(
    label: 'KRAWCZYK',
    taskType: GrafikTaskType.Inne,
    status: GrafikStatus.Realizacja,
    orderId: '0001',
    carIds: ['QqYtL81vjbmpi6859Q9Y'],
    startHour: 7,
    endHour: 15,
    additionalInfo: 'Zaopatrzenie/Serwisy',
  ),
];
