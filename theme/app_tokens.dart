
import 'package:flutter/material.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'dart:math' as math;

/// Stałe odstępów, marginesów, paddingów
class AppSpacing {
  static const double xxs = 1.0;
  static const double xs = 2.0;
  static const double sm = 4.0;
  static const double lg = 8.0;

  static double _scale(Breakpoint bp) {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final shortSide =
        math.min(view.physicalSize.width, view.physicalSize.height) /
            view.devicePixelRatio;
    final factor = shortSide >= 600
        ? (shortSide / 600).clamp(1.2, 1.6)
        : 1.0;
    switch (bp) {
      case Breakpoint.small:
        return 1.0 * factor;
      case Breakpoint.medium:
        return 1.5 * factor;
      case Breakpoint.large:
        return 2.0 * factor;
    }
  }

  static double scaled(double base, Breakpoint bp) => base * _scale(bp);

  /// Szerokość obramowania
  static const double borderThin = 1.0;
  static const double borderMedium = 2.0;

  /// Odpowiednik .withOpacity(0.1) => alpha ~ 25
  static const int alphaLow = 25;

  /// Wysokości kafelków (aliasy do SizeVariant, dla wygody w layoutach).
  static const double tileLarge  = 48;
  static const double tileMedium = 32;
  static const double tileSmall  = 20;
  static const double tileMini   = 16;
}

/// Promienie zaokrągleń (border radius)
class AppRadius {
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
}

// Obrazki używane w aplikacji
class AppAssets {
  static const logoGradient = 'lib/assets/images/logo_gradient.png';
}

/// Teksty używane w aplikacji
class AppStrings {
  static const pickDateRange = 'Wybierz zakres dat';
  static const pickDay = 'Wybierz dzień';
  static const dateLabel = 'Date: ';

  // Dla slidera czasu
  static String selectTimeRange(int startHour, int endHour) =>
      'Select Time Range: $startHour h - $endHour h';

  static const yes = 'Tak';
  static const no = 'Nie';

  static const reset = 'Zeruj';
  static const workHoursLabel = 'Czas (roboczogodziny)';
  static const numberLabel = 'Przewidywana ilość pracowników:';

  // Przydatne drobiazgi
  static const dayPickerDefaultLabel = 'Wybierz dzień';
  static const date = 'Date: ';

  // Ogólne
  static const saveVehicle = 'Zapisz pojazd';
  static const color = 'Kolor';
  static const brand = 'Marka';
  static const model = 'Model';
  static const registrationNumber = 'Rejestracja';
  static const vehicleType = 'Typ';
  static const sittingCapacity = 'Ilość miejsc';
  static const cargoDimensions = 'Wymiary ładunku';
  static const maxLoad = 'Maksymalny załadunek';

  // Home
  static const homeScreenTitle = 'Home Screen';
  static const welcomeHome = 'Welcome to Home Screen!';
  static const goToGrafikTest = 'Go to Grafik Test Screen';
  static const goToGrafik = 'Przejdź do ekranu Grafiku';

  // Login
  static const loginRegisterTitle = 'Login / Register';
  static const fullName = 'Nazwisko Imię'; // zmienione
  static const email = 'Email';
  static const password = 'Password';
  static const register = 'Załóż konto'; // zmienione
  static const login = 'Zaloguj'; // zmienione

  // Grafik
  static const grafik = 'Grafik';
  static const weekView = 'Widok tygodniowy';
  static const gotoWeekGrafik = 'Widok tygodniowy'; // jeśli potrzebne
  static const dateRangePicker = 'Wybierz zakres dat';
  static const pickDate = 'Wybierz datę';
  static const showAllGrafik = 'Pokaż cały grafik';
  static const showMyGrafik = 'Pokaż mój grafik';

  static const zero = 'Zeruj';
  static const save = 'Zapisz';
  static const chooseVehicle = 'Wybierz pojazdy';
  static const chooseEmployees = 'Wybierz pracowników';

  // Dodatkowe (np. do WeekGrafikView)
  static const previousWeek = 'Poprzedni tydzień';
  static const nextWeek = 'Następny tydzień';

  // Inne teksty, w razie potrzeby
  static const colorText = 'Color';
  static const brandText = 'Brand';
  static const modelText = 'Model';
  static const typeText = 'Type';
  static const sittingCapacityText = 'SittingCapacity';
  static const cargoDimensionsText = 'CargoDimensions';
  static const maxLoadText = 'MaxLoad';
  static const noTasksToday = 'Brak zadań na dziś.\nŚmiało planuj 👷';


  static const noAccessTitle = 'Brak dostępu';
  static const noAccessMessage = 'Nie posiadasz dostępu do aplikacji.';
  static const noAccessInstructions = 'Skonsultuj się z dostawcą oprogramowania w celu nadania uprawnień.';
  static const registerUser = 'Utwórz użytkownika';
  static const logoAlt = 'Logo aplikacji';
  static const signInError = 'Ups! Coś poszło nie tak. Sprawdź dane logowania i połączenie z internetem.';
  static const assignEmployeeTitle = 'Przypisz pracownika';
  static const noEmployeeAssigned = 'Nie przypisano konta do pracownika';
  static const assignMe = 'Przypisz mnie';
  static const employeeAlreadyAssigned =
      'Wybrany pracownik jest już przypisany do innego konta';
}
