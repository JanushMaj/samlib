import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/shared/responsive/responsive_chip.dart';
import 'package:kabast/shared/responsive/responsive_chip_list.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import '../../../../domain/models/grafik/enums.dart';
import '../dialog/grafik_element_popup.dart';
import 'transfer_list.dart';

class TaskTile extends StatelessWidget {
  final TaskElement task;
  const TaskTile({Key? key, required this.task}) : super(key: key);

  // Mapy ikon i kolorów
  static const _typeIcons = {
    GrafikTaskType.Produkcja: Icons.apartment,
    GrafikTaskType.Budowa:     Icons.home_repair_service,
    GrafikTaskType.Serwis:     Icons.handyman,
    GrafikTaskType.Inne:       Icons.task_alt,
  };
  static const _borderColors = {
    GrafikTaskType.Produkcja: Colors.blue,
    GrafikTaskType.Budowa:     Colors.orange,
    GrafikTaskType.Serwis:     Colors.green,
    GrafikTaskType.Inne:       Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    // Format czasu HH:MM
    String fmt(DateTime dt) =>
        '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';

    // Pobierz dane
    final state      = context.watch<GrafikCubit>().state;
    final employees  = state.employees.where((e) => task.workerIds.contains(e.uid));
    final vehicles   = state.vehicles .where((v) => task.carIds.contains(v.id));
    final transfers  = state.taskTransferDisplayMapping[task.id];

    // Kafelki pojazdów (używamy ResponsiveChipList)
    final vehicleChips = vehicles
        .map((v) => ResponsiveChip(label: '${v.brand} ${v.color}', icon: Icons.fire_truck))
        .toList();

    final typeIcon    = _typeIcons   [task.taskType] ?? Icons.task;
    final borderColor = _borderColors[task.taskType] ?? Colors.grey;
    final statusIcon  = task.status.icon;

    return GestureDetector(
      onTap: () => showGrafikElementPopup(context, task),
      child: Container(
        margin: const EdgeInsets.only(
          left: AppSpacing.xs,
          right: AppSpacing.xs,
          bottom: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: AppSpacing.borderThin),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Górny wiersz: ikona typu – teksty – ikona statusu
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(typeIcon, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. AdditionalInfo
                        Text(
                          task.additionalInfo,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // 2. OrderId
                        Text(
                          task.orderId,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // 4. Godziny
                        Text(
                          '${fmt(task.startDateTime)}–${fmt(task.endDateTime)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(statusIcon, size: 28),
                ],
              ),
            ),
            // Drugi wiersz: pracownicy z pogrubioną pierwszą literą
            if (employees.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: employees.map((e) {
                    final name = e.formattedNameWithSecondInitial;
                    final parts = name.split(' ');
                    final surname = parts.first;
                    final rest = name.substring(surname.length);
                    // RichText z pogrubioną pierwszą literą
                    return Chip(
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: surname.substring(0,1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: surname.substring(1) + rest,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                      labelPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            // Trzeci wiersz: pojazdy
            if (vehicleChips.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: ResponsiveChipList(chips: vehicleChips),
              ),
            // Komunikaty transferowe
            if (transfers != null && transfers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: TransferList(transferInfo: transfers),
              ),
          ],
        ),
      ),
    );
  }
}
