import 'package:kabast/domain/models/grafik/enums.dart';
import 'package:kabast/domain/models/grafik/grafik_element.dart';

/// Element planowania dostaw.
class DeliveryPlanningElement extends GrafikElement {
  final String orderId;
  final DeliveryPlanningCategory category;

  DeliveryPlanningElement({
    required String id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String additionalInfo,
    required this.orderId,
    required this.category,
    required String addedByUserId,
    required DateTime addedTimestamp,
    required bool closed,
  }) : super(
    id: id,
    startDateTime: startDateTime,
    endDateTime: endDateTime,
    type: 'DeliveryPlanningElement',
    additionalInfo: additionalInfo,
    addedByUserId: addedByUserId,
    addedTimestamp: addedTimestamp,
    closed: closed,
  );

}
