import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/enums.dart';

extension GrafikStatusX on GrafikStatus {
  IconData get icon {
    switch (this) {
      case GrafikStatus.Realizacja:
        return Icons.play_arrow;
      case GrafikStatus.Wstrzymane:
        return Icons.pause;
      case GrafikStatus.Zakonczone:
        return Icons.check;
      case GrafikStatus.Anulowane:
        return Icons.cancel;
    }
  }
}
