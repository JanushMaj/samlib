import '../../domain/models/grafik/impl/transport_plan.dart' as grafik;
import '../repositories/grafik_element_repository.dart';

class TransportPlanRepository {
  final GrafikElementRepository _grafikRepository;
  TransportPlanRepository(this._grafikRepository);

  Future<void> saveTransportPlan(grafik.TransportPlan plan) {
    return _grafikRepository.saveGrafikElement(plan);
  }

  Future<void> deleteTransportPlan(String id) {
    return _grafikRepository.deleteGrafikElement(id);
  }
}
