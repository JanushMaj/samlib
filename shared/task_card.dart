import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/grafik_element_data.dart';
import 'package:kabast/theme/size_variants.dart';
import 'utils/tile_size_resolver.dart';
import 'grafik_element_card.dart';

class TaskCard extends StatelessWidget {
  final TaskElement task;
  final GrafikElementData data;
  final SizeVariant? variant;

  const TaskCard({
    Key? key,
    required this.task,
    required this.data,
    this.variant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sizeVariant =
            variant ?? TileSizeResolver.resolve(width: constraints.maxWidth);

        return GrafikElementCard(
          element: task,
          data: data,
          variant: sizeVariant,
        );
      },
    );
  }
}
