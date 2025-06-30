import 'package:kabast/shared/turbo_grid/turbo_tile_delegate.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_variant.dart';

/// Model pojedynczego kafelka dla TurboGrid.
/// Przechowuje właściwości kafelka (priorytet, czy wymagany) oraz delegata
/// generującego warianty wyświetlania.
/// Wzorzec Fabryka: TurboTileDelegate działa jak fabryka tworząca konkretne
/// reprezentacje (TurboTileVariant) kafelka.
class TurboTile {
  /// Niższa wartość oznacza wyższy priorytet (bardziej istotny kafelek).
  final int priority;

  /// Czy kafelek musi zostać wyświetlony (true) czy może zostać usunięty, jeśli brakuje miejsca (false).
  final bool required;

  /// Delegat dostarczający warianty wyświetlania kafelka.
  final TurboTileDelegate delegate;

  /// Lista wariantów (reprezentacji) kafelka, od największej do najmniejszej.
  late final List<TurboTileVariant> variants;

  TurboTile({
    required this.priority,
    required this.required,
    required this.delegate,
  }) {
    // Tworzymy warianty kafelka za pomocą delegata (fabryki).
    variants = delegate.createVariants();
  }
}
