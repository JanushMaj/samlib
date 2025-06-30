enum VehicleType { osobowka, dostawczy }

class Vehicle {
  final String id;
  final String color;
  final String brand;
  final String model;
  final String nrRejestracyjny;
  final VehicleType type;
  final int sittingCapacity;
  final String cargoDimensions;
  final String maxLoad;

  Vehicle({
    required this.id,
    required this.color,
    required this.brand,
    required this.model,
    required this.nrRejestracyjny,
    required this.type,
    required this.sittingCapacity,
    required this.cargoDimensions,
    required this.maxLoad,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color': color,
      'brand': brand,
      'model': model,
      'nrRejestracyjny': nrRejestracyjny,
      'type': type.toString().split('.').last,
      'sittingCapacity': sittingCapacity,
      'cargoDimensions': cargoDimensions,
      'maxLoad': maxLoad,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    T getValue<T>(String key, {T? defaultValue}) {
      final value = json[key];
      if (value == null) return defaultValue as T;

      if (T == String) return value.toString() as T;
      if (T == int) {
        if (value is int) return value as T;
        if (value is String) return int.tryParse(value) as T? ?? defaultValue as T;
      }
      return value as T? ?? defaultValue as T;
    }

    VehicleType parseVehicleType(String? typeStr) {
      return VehicleType.values.firstWhere(
            (e) => e.toString().split('.').last == typeStr,
        orElse: () => VehicleType.osobowka,
      );
    }

    return Vehicle(
      id: getValue<String>('id', defaultValue: ''),
      color: getValue<String>('color', defaultValue: ''),
      brand: getValue<String>('brand', defaultValue: 'Unknown'),
      model: getValue<String>('model', defaultValue: 'Unknown'),
      nrRejestracyjny: getValue<String>('nrRejestracyjny', defaultValue: ''),
      type: parseVehicleType(getValue<String>('type')),
      sittingCapacity: getValue<int>('sittingCapacity', defaultValue: 0),
      cargoDimensions: getValue<String>('cargoDimensions', defaultValue: ''),
      maxLoad: getValue<String>('maxLoad', defaultValue: ''),
    );
  }
}
