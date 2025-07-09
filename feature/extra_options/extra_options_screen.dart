import 'package:flutter/material.dart';

class ExtraOptionsScreen extends StatelessWidget {
  const ExtraOptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodatkowe opcje'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Text(
                  'Dwa tygodnei zdalnego i mogą być tu cuda',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
