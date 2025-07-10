import 'package:flutter/material.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';

class ExtraOptionsScreen extends StatelessWidget {
  const ExtraOptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Dodatkowe opcje'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ResponsivePadding(
              small: const EdgeInsets.all(16.0),
              medium: const EdgeInsets.all(24.0),
              large: const EdgeInsets.all(32.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Text(
                    'Dwa tygodnei zdalnego i mogą być tu cuda',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
