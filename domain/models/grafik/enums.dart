import 'package:flutter/material.dart';

enum GrafikStatus {
  Realizacja,
  Wstrzymane,
  Zakonczone,
  Anulowane,
}
extension GrafikStatusX on GrafikStatus {
  IconData get icon {
    switch (this) {
      case GrafikStatus.Realizacja: return Icons.play_arrow;
      case GrafikStatus.Wstrzymane:  return Icons.pause;
      case GrafikStatus.Zakonczone:  return Icons.check;
      case GrafikStatus.Anulowane:   return Icons.cancel; // ✨ można podmienić
    }
  }
}

enum GrafikTaskType {
  Serwis,
  Produkcja,
  Budowa,
  Inne,
}

enum GrafikProbability {
  Pewne,
  Prawdopodobne,
  Kociuba,
}

enum PaymentType {
  zero,        // 0%
  eighty,      // 80%
  oneHundred,  // 100%
  oneFifty,    // 150%
  twoHundred,  // 200%
}


enum TimeIssueType {
  Spoznienie,        // Spóźnienie
  Wyjscie,   // Wcześniejsze wyjście
  Nieobecnosc,      // Nieobecność (urlop, choroba)
  Przeniesienie,     // Przeniesienie między zadaniami
  Nadgodziny,     // Nadgodziny
  Niestandardowe,       // Niestandardowe zdarzenia
}

enum DeliveryPlanningCategory {
  Profile,
  Wypelnienia,
  Akcesoria,
  Inne,
}

