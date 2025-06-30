import 'turbo_tile_variant.dart';

/// Abstrakcyjny delegat definiujący możliwe warianty wyświetlania dla kafelka.
/// Wzorzec Strategia: różne implementacje tego delegata mogą dostarczać różne
/// sposoby prezentacji zawartości kafelka przy różnych poziomach szczegółowości.
abstract class TurboTileDelegate {
  /// Zwraca listę dostępnych wariantów wyświetlania (od najbardziej szczegółowego
  /// do najbardziej uproszczonego).
  /// Wskazówka: Lista powinna zaczynać się od wariantu największego/pełnego,
  /// a kończyć na najmniejszym.
  List<TurboTileVariant> createVariants();
}
