import 'package:flutter/material.dart';

/// Reprezentacja (wariant) wyświetlania pojedynczego kafelka TurboTile.
/// Zawiera widget (lub budowniczy widgetu) dla danego poziomu szczegółowości
/// oraz rozmiar, jaki ten widget powinien zajmować.
class TurboTileVariant {
  /// Rozmiar (szerokość i wysokość) jaki kafelek zajmuje przy tej reprezentacji.
  final Size size;

  /// Budowniczy, który generuje zawartość kafelka dla tego wariantu.
  final WidgetBuilder builder;

  TurboTileVariant({required this.size, required this.builder});
}
