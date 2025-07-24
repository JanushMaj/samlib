import 'package:test/test.dart';

import 'package:kabast/domain/models/grafik/impl/service_request_element.dart';
import 'package:kabast/domain/models/grafik/enums.dart';
import 'package:kabast/data/dto/grafik/service_request_element_dto.dart';

void main() {
  test('service request dto serialization round trip', () {
    final req = ServiceRequestElement(
      id: 'r1',
      createdBy: 'u1',
      createdAt: DateTime(2024, 1, 1),
      location: 'loc',
      description: 'desc',
      orderNumber: 'ord1',
      urgency: ServiceUrgency.pilne,
      suggestedDate: DateTime(2024, 1, 10),
      estimatedDuration: const Duration(minutes: 90),
      requiredPeopleCount: 2,
    );

    final dto = ServiceRequestElementDto.fromDomain(req);
    final json = dto.toJson();
    final recreated = ServiceRequestElementDto.fromJson(json).toDomain();

    expect(recreated.location, req.location);
    expect(recreated.description, req.description);
    expect(recreated.orderNumber, req.orderNumber);
    expect(recreated.urgency, req.urgency);
    expect(recreated.suggestedDate, req.suggestedDate);
    expect(recreated.estimatedDuration, req.estimatedDuration);
    expect(recreated.requiredPeopleCount, req.requiredPeopleCount);
  });
}
