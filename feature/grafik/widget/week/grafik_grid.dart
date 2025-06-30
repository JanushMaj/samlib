import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/domain/models/grafik/grafik_element.dart';
import 'event_layout_logic.dart';

class GrafikGrid extends StatelessWidget {
  final DateTime startDate;
  final int dayCount;
  final List<GrafikElement> elements;
  final String Function(GrafikElement) labelBuilder;
  final Widget Function(GrafikElement)? weekTileBuilder;

  const GrafikGrid({
    super.key,
    required this.startDate,
    required this.dayCount,
    required this.elements,
    required this.labelBuilder,
    this.weekTileBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // 1️⃣  Najpierw wyliczamy wiersze eventów
    final rows = DayBasedLayoutLogic.layoutEvents(
      all: elements,
      startOfGrid: _dayOnly(startDate),
      dayCount: dayCount,
    );

    // 2️⃣  LayoutBuilder da nam faktyczną szerokość siatki
    return LayoutBuilder(
      builder: (context, gridConstraints) {
        final gridWidth = gridConstraints.maxWidth;

        return Column(
          children: [
            // ─────────  Pasek dat  ─────────
            SizedBox(
              height: 20,
              child: Row(
                children: List.generate(dayCount, (index) {
                  final date = _dayOnly(startDate).add(Duration(days: index));
                  final txt =
                      "${_formatDate(date)} - ${_weekdayShortName(date)}";
                  return Expanded(
                    child: Center(
                      child: Text(
                        txt,
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ─────────  Wiersze z eventami  ─────────
            ...List.generate(rows.length, (rowIndex) {
              final rowElems = rows[rowIndex].elements;

              return Expanded(
                child: Stack(
                  children: rowElems.map((elem) {
                    // indeksy kolumn dla elementu
                    final li = _dayIndexOf(elem.startDateTime, startDate)
                        .clamp(0, dayCount - 1);
                    final ri = _dayIndexOf(elem.endDateTime, startDate)
                        .clamp(0, dayCount - 1);

                    final span          = (ri - li + 1).clamp(1, dayCount);
                    final widthFraction = span / dayCount;
                    final leftFraction  = li   / dayCount;

                    // 🔥  liczymy wszystko z użyciem gridWidth,
                    //     a nie pełnego MediaQuery
                    final leftPx  = gridWidth * leftFraction;
                    final rightPx = gridWidth *
                        (1.0 - (leftFraction + widthFraction));

                    return Positioned(
                      left  : leftPx,
                      right : rightPx,
                      top   : AppSpacing.xs,
                      bottom: AppSpacing.xs,
                      child : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: AppSpacing.borderThin,
                          ),
                        ),
                        child: weekTileBuilder != null
                            ? weekTileBuilder!(elem)
                            : FittedBox(
                          alignment: Alignment.topLeft,
                          fit : BoxFit.scaleDown,
                          child: Text(labelBuilder(elem)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Helpery dat / indeksów
  // ────────────────────────────────────────────────────────────
  String _formatDate(DateTime date) =>
      "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}";

  String _weekdayShortName(DateTime date) =>
      const ['Pon', 'Wt', 'Śr', 'Czw', 'Pt', 'Sob', 'Ndz'][date.weekday - 1];

  int _dayIndexOf(DateTime dt, DateTime start) =>
      dt.difference(_dayOnly(start)).inDays;

  DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
