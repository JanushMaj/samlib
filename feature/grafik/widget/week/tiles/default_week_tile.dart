import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/grafik_element.dart';

class DefaultWeekTile extends StatelessWidget {
  final GrafikElement element;
  const DefaultWeekTile({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Nieznany typ: ${element.type}"),
    );
  }
}
