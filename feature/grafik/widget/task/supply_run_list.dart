import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/domain/models/grafik/impl/supply_run_element.dart';
import 'package:kabast/domain/models/grafik/grafik_element_data.dart';
import 'package:kabast/shared/grafik_element_card.dart';
import 'package:kabast/shared/utils/tile_size_resolver.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/theme.dart';

import '../../../auth/auth_cubit.dart';
import '../../cubit/grafik_cubit.dart';
import '../../cubit/grafik_state.dart';

class SupplyRunList extends StatelessWidget {
  final Breakpoint breakpoint;
  final bool showAll;

  const SupplyRunList({
    Key? key,
    required this.breakpoint,
    required this.showAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrafikCubit, GrafikState>(
      builder: (context, state) {
        List<SupplyRunElement> runs = List.from(state.supplyRuns);
        if (!showAll) {
          final userId = context.read<AuthCubit>().currentUser?.employeeId;
          runs = runs.where((r) => r.addedByUserId == userId).toList();
        }

        runs.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

        if (runs.isEmpty) {
          return const SizedBox.shrink();
        }

        final columns = switch (breakpoint) {
          Breakpoint.small => 1,
          Breakpoint.medium => 2,
          Breakpoint.large => 2,
        };

        return LayoutBuilder(
          builder: (context, gridConstraints) {
            final runCount = runs.length;
            final rows = (runCount / columns).ceil();

            final totalSpacingHeight =
                AppSpacing.sm * (rows > 0 ? rows - 1 : 0);
            final availableHeight =
                gridConstraints.maxHeight - totalSpacingHeight;
            final tileHeight =
                rows > 0 ? availableHeight / rows : gridConstraints.maxHeight;

            final tileWidth =
                (gridConstraints.maxWidth - AppSpacing.sm * (columns - 1)) /
                    columns;
            final aspectRatio = tileWidth / tileHeight;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: aspectRatio,
              ),
              itemCount: runs.length,
              itemBuilder: (context, index) {
                final run = runs[index];
                const data = GrafikElementData(
                  assignedEmployees: [],
                  assignedVehicles: [],
                );
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final variant = TileSizeResolver.resolve(
                      width: constraints.maxWidth,
                    );
                    return GrafikElementCard(
                      element: run,
                      data: data,
                      variant: variant,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
