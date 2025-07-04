enum GrafikStatus {
  Realizacja,
  Wstrzymane,
  Zakonczone,
  Anulowane,
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

