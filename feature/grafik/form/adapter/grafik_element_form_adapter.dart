import 'package:kabast/data/dto/grafik/grafik_element_dto.dart';
import 'package:kabast/feature/grafik/form/grafik_element_registry.dart';
import 'package:kabast/domain/models/grafik/grafik_element.dart';

class GrafikElementFormAdapter {
  GrafikElement toDomainFromDto(GrafikElementDto dto) => dto.toDomain();

  GrafikElementDto toDtoFromDomain(GrafikElement element) =>
      GrafikElementDto.fromDomain(element);

  GrafikElement changeType(GrafikElement oldElement, String newType) {
    final newElement =
        GrafikElementRegistry.createDefaultElementForType(newType);
    final newJson = GrafikElementDto.fromDomain(newElement).toJson();
    final oldJson = GrafikElementDto.fromDomain(oldElement).toJson();

    newJson['id'] = oldJson['id'];
    newJson['startDateTime'] = oldJson['startDateTime'];
    newJson['endDateTime'] = oldJson['endDateTime'];
    newJson['additionalInfo'] = oldJson['additionalInfo'];

    return GrafikElementDto.fromJson(newJson).toDomain();
  }

  GrafikElement updateField(
    GrafikElement element,
    String field,
    dynamic value,
  ) {
    final map = GrafikElementDto.fromDomain(element).toJson();
    if (field == 'startDateTime' || field == 'endDateTime') {
      if (value is DateTime) {
        map[field] = value;
      }
    } else {
      map[field] = value;
    }

    return GrafikElementDto.fromJson(map).toDomain();
  }

  GrafikElement copyWithOverrides(
    GrafikElement element,
    Map<String, dynamic> overrides,
  ) {
    final map = GrafikElementDto.fromDomain(element).toJson();
    overrides.forEach((key, val) {
      map[key] = val;
    });
    return GrafikElementDto.fromJson(map).toDomain();
  }

  GrafikElement fillMeta(GrafikElement element, String userId) {
    final needUser = (element.addedByUserId).isEmpty;
    final needTs = element.addedTimestamp.isBefore(DateTime(1970));

    if (!needUser && !needTs) return element;

    final json = GrafikElementDto.fromDomain(element).toJson();
    if (needUser) json['addedByUserId'] = userId;
    if (needTs) json['addedTimestamp'] = DateTime.now();

    return GrafikElementDto.fromJson(json).toDomain();
  }
}
