import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/impl/delivery_planning_element.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile.dart';
import 'package:kabast/shared/turbo_grid/turbo_grid.dart';
import 'package:kabast/theme/app_tokens.dart';

import '../../../../../shared/turbo_grid/widgets/clock_view_delegate.dart';
import '../../../../../shared/turbo_grid/widgets/simple_text_delegate.dart';
import '../../dialog/grafik_element_popup.dart';
import '../../../constants/element_styles.dart';

class DeliveryPlanningWeekTile extends StatelessWidget {
  final DeliveryPlanningElement deliveryPlanning;

  const DeliveryPlanningWeekTile({Key? key, required this.deliveryPlanning})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = const GrafikElementStyleResolver().styleFor(deliveryPlanning.type);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: GestureDetector(
        onTap: () => showGrafikElementPopup(context, deliveryPlanning),
        child: Container(
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return TurboGrid(
                tiles: [
                  // 1. Zegar: czas od..do
                  TurboTile(
                    priority: 1,
                    required: true,
                    delegate: ClockViewDelegate(
                      start: deliveryPlanning.startDateTime,
                      end: deliveryPlanning.endDateTime,
                    ),
                  ),
                  // 2. Additional info
                  TurboTile(
                    priority: 1,
                    required: true,
                    delegate: SimpleTextDelegate(
                      text: deliveryPlanning.additionalInfo,
                    ),
                  ),
                  // 3. Numer zamówienia
                  TurboTile(
                    priority: 3,
                    required: true,
                    delegate: SimpleTextDelegate(
                      text: deliveryPlanning.orderId,
                    ),
                  ),
                  // 4. Kategoria
                  TurboTile(
                    priority: 4,
                    required: true,
                    delegate: SimpleTextDelegate(
                      text: deliveryPlanning.category.name,
                    ),
                  ),
                  // 5. Tekst stały (opcjonalny)
                  TurboTile(
                    priority: 5,
                    required: false,
                    delegate: SimpleTextDelegate(
                      text: "DeliveryPlanningElement",
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
