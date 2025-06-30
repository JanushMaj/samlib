import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  const CustomTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final _ctrl = TextEditingController(text: widget.initialValue);

  @override
  void didUpdateWidget(covariant CustomTextField old) {
    super.didUpdateWidget(old);
    // aktualizuj tekst tylko gdy zmienił się zewnętrzny stan,
    // ale NIE nadpisuj tego, co właśnie wpisuje użytkownik
    if (widget.initialValue != old.initialValue && _ctrl.text != widget.initialValue) {
      _ctrl.text = widget.initialValue;
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => widget.onChanged(_ctrl.text));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      decoration: InputDecoration(labelText: widget.label),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
