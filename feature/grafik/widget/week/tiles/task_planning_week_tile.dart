import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/impl/task_planning_element.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile.dart';
import 'package:kabast/shared/turbo_grid/turbo_grid.dart';
import 'package:kabast/theme/app_tokens.dart';

import '../../../../../shared/turbo_grid/widgets/clock_view_delegate.dart';
import '../../../../../shared/turbo_grid/widgets/simple_text_delegate.dart';
import '../../../../../shared/turbo_grid/widgets/work_time_planning_delegate.dart';
import '../../dialog/grafik_element_popup.dart';

class TaskPlanningWeekTile extends StatelessWidget {
  final TaskPlanningElement taskPlanning;
  const TaskPlanningWeekTile({Key? key, required this.taskPlanning}) : super(key: key);

  Color _backgroundColor(BuildContext context) => Colors.green.shade100;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: GestureDetector(
        onTap: () => showGrafikElementPopup(context, taskPlanning),
        child: Stack(
          children: [
            // ---------- główny kafelek ----------
            Container(
              decoration: BoxDecoration(
                color: _backgroundColor(context),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: LayoutBuilder(
                builder: (context, constraints) => TurboGrid(
                  tiles: [
                    TurboTile(
                      priority: 1,
                      required: true,
                      delegate: ClockViewDelegate(
                        start: taskPlanning.startDateTime,
                        end: taskPlanning.endDateTime,
                      ),
                    ),
                    TurboTile(
                      priority: 1,
                      required: true,
                      delegate: SimpleTextDelegate(text: taskPlanning.additionalInfo),
                    ),
                    TurboTile(
                      priority: 2,
                      required: false,
                      delegate: SimpleTextDelegate(text: taskPlanning.orderId),
                    ),
                    TurboTile(
                      priority: 3,
                      required: false,
                      delegate: SimpleTextDelegate(
                        text: taskPlanning.probability.toString(),
                      ),
                    ),
                    // UWAGA: to pole było tekstem – usuwamy,
                    // bo teraz sygnalizujemy priorytet ikoną
                    TurboTile(
                      priority: 4,
                      required: false,
                      delegate: SimpleTextDelegate(text: taskPlanning.taskType.name),
                    ),
                    TurboTile(
                      priority: 5,
                      required: false,
                      delegate: WorkTimePlanningDelegate(
                        workerCount: taskPlanning.workerCount,
                        minutes: taskPlanning.minutes,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------- badge priorytetu ----------
            if (taskPlanning.highPriority)
              Positioned(
                bottom: 4,
                right: 4,
                child: Icon(
                  Icons.priority_high,
                  color: Colors.red.shade700,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
