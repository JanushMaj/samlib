import 'grafik_element_registry.dart';
import '../../../domain/models/grafik/grafik_element.dart';
import '../../../data/repositories/grafik_element_repository.dart';
import '../../../injection.dart';

class GrafikElementFormAdapter {
  final GrafikElementRepository _repo;

  GrafikElementFormAdapter({GrafikElementRepository? repo})
      : _repo = repo ?? getIt<GrafikElementRepository>();

  GrafikElement changeType(GrafikElement oldElement, String newType) {
    final newElement =
        GrafikElementRegistry.createDefaultElementForType(newType);
    final newJson = _repo.toJson(newElement);
    final oldJson = _repo.toJson(oldElement);

    newJson['id'] = oldJson['id'];
    newJson['startDateTime'] = oldJson['startDateTime'];
    newJson['endDateTime'] = oldJson['endDateTime'];
    newJson['additionalInfo'] = oldJson['additionalInfo'];

    return _repo.fromJson(newJson);
  }

  GrafikElement updateField(
    GrafikElement element,
    String field,
    dynamic value,
  ) {
    final map = _repo.toJson(element);
    if (field == 'startDateTime' || field == 'endDateTime') {
      if (value is DateTime) {
        map[field] = value;
      }
    } else {
      map[field] = value;
    }

    return _repo.fromJson(map);
  }

  GrafikElement copyWithOverrides(
    GrafikElement element,
    Map<String, dynamic> overrides,
  ) {
    final map = _repo.toJson(element);
    overrides.forEach((key, val) {
      map[key] = val;
    });
    return _repo.fromJson(map);
  }

  GrafikElement fillMeta(GrafikElement element, String userId) {
    final needUser = (element.addedByUserId).isEmpty;
    final needTs = element.addedTimestamp.isBefore(DateTime(1970));

    if (!needUser && !needTs) return element;

    final json = _repo.toJson(element);
    if (needUser) json['addedByUserId'] = userId;
    if (needTs) json['addedTimestamp'] = DateTime.now();

    return _repo.fromJson(json);
  }
}
