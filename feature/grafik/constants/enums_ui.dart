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

extension GrafikTaskTypeX on GrafikTaskType {
  IconData get icon {
    switch (this) {
      case GrafikTaskType.Budowa:
        return Icons.construction;
      case GrafikTaskType.Produkcja:
        return Icons.precision_manufacturing;
      case GrafikTaskType.Serwis:
        return Icons.handyman;
      case GrafikTaskType.Inne:
        return Icons.more_horiz;
    }
  }
}
