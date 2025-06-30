import 'package:flutter/material.dart';
import 'turbo_tile.dart'; // <-- popraw ścieżkę jeśli masz inny układ folderów

/// TurboGrid – widget układający dynamicznie kafelki (TurboTile) w dostępnej przestrzeni,
/// przyjmując listę kafelków w konstruktorze. Nie zmieniamy nazwy, parametrów ani nic innego.
///
/// Zmieniamy wyłącznie wewnętrzną logikę (iteracyjną z pętlą) dopasowania i układu kafelków.
// turbo_grid.dart  (UPROSZCZONY)

// turbo_grid.dart  (UPROSZCZONY, ale poprawny)

import 'package:flutter/material.dart';
import 'turbo_tile.dart';

class TurboGrid extends StatelessWidget {
  final List<TurboTile> tiles;
  const TurboGrid({Key? key, required this.tiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final layout = _computeLayout(
          tiles,
          constraints.maxWidth,
          constraints.maxHeight,
        );

        final children = _buildPositioned(
          ctx,
          layout.states.where((s) => !s.excluded).toList(),
          constraints.maxWidth,
        );

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(children: children),
        );
      },
    );
  }

  // ------------------ LOGIKA UPROSZCZONA ------------------
  _LayoutResult _computeLayout(
      List<TurboTile> input, double maxW, double maxH) {
    // Kopia + sort rosnąco po priority
    final tiles = List<TurboTile>.from(input)
      ..sort((a, b) => a.priority.compareTo(b.priority));

    final states = [
      for (final t in tiles)
        _TileState(tile: t, variantIndex: 0, excluded: false)
    ];

    const lastVariant = 2; // 0‑big,1‑medium,2‑small

    // 1‑3. big → medium → small
    for (var lvl = 0; lvl <= lastVariant; lvl++) {
      for (final s in states) s.variantIndex = lvl;
      if (_fits(states, maxW, maxH)) {
        return _LayoutResult(states, true);
      }
    }

    // 4. wyrzucamy opcjonalne od najniższego priorytetu
    final optionalDesc = states
        .where((s) => !s.tile.required)
        .toList()
      ..sort((a, b) => b.tile.priority.compareTo(a.tile.priority));

    for (final s in optionalDesc) {
      s.excluded = true;
      if (_fits(states, maxW, maxH)) {
        return _LayoutResult(states, true);
      }
    }

    // Zostały same required i nadal overflow
    return _LayoutResult(states, false);
  }

  // ------------------ SPRAWDZANIE FITU ------------------
  bool _fits(List<_TileState> sts, double maxW, double maxH) {
    double x = 0, y = 0, rowH = 0;

    for (final s in sts) {
      if (s.excluded) continue;
      final v = s.tile.variants[s.variantIndex];
      final w = v.size.width;
      final h = v.size.height;

      if (w > maxW || h > maxH) return false;

      if (x + w > maxW && x != 0) {
        x = 0;
        y += rowH;
        rowH = 0;
      }
      if (y + h > maxH) return false;

      x += w;
      if (h > rowH) rowH = h;
    }
    return y + rowH <= maxH;
  }

  // ------------------ BUDOWANIE WIDGETÓW ------------------
  List<Positioned> _buildPositioned(
      BuildContext ctx, List<_TileState> active, double maxW) {
    double x = 0, y = 0, rowH = 0;
    final out = <Positioned>[];

    for (final s in active) {
      final v = s.tile.variants[s.variantIndex];
      final w = v.size.width;
      final h = v.size.height;

      if (x + w > maxW && x != 0) {
        x = 0;
        y += rowH;
        rowH = 0;
      }

      out.add(
        Positioned(
          left: x,
          top: y,
          child: SizedBox(width: w, height: h, child: v.builder(ctx)),
        ),
      );

      x += w;
      if (h > rowH) rowH = h;
    }
    return out;
  }
}

// ------------------ POMOCNICZE KLASY ------------------
class _TileState {
  final TurboTile tile;
  int variantIndex;
  bool excluded;
  _TileState({
    required this.tile,
    required this.variantIndex,
    required this.excluded,
  });
}

class _LayoutResult {
  final List<_TileState> states;
  final bool fits;
  _LayoutResult(this.states, this.fits);
}
