import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/feature/grafik/cubit/grafik_state.dart';
import 'package:kabast/feature/grafik/widget/single_day_grafik_view.dart';

class GrafikWrapper extends StatelessWidget {
  const GrafikWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrafikCubit, GrafikState>(
      builder: (context, state) {
        // Możesz tu dodać obsługę loading/error, jeśli to konieczne.
        return SingleDayGrafikView(date: state.selectedDay);
      },
    );
  }
}
