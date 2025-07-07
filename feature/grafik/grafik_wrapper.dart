import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/date/date_cubit.dart';
import 'package:kabast/feature/grafik/widget/single_day_grafik_view.dart';

class GrafikWrapper extends StatelessWidget {
  const GrafikWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateCubit, DateState>(
      builder: (context, dateState) {
        return SingleDayGrafikView(date: dateState.selectedDay);
      },
    );
  }
}
