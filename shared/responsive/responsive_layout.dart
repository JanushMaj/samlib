import "package:flutter/material.dart";
import 'dart:math' as math;
enum Breakpoint { small, medium, large }

/// Returns the [Breakpoint] for the given shortest side length.
Breakpoint breakpointFromWidth(double shortSide) {
  if (shortSide < 600) return Breakpoint.small;
  if (shortSide < 1000) return Breakpoint.medium;
  return Breakpoint.large;
}

class BreakpointProvider extends InheritedWidget {
  final Breakpoint breakpoint;
  const BreakpointProvider({
    super.key,
    required this.breakpoint,
    required super.child,
  });

  static Breakpoint of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<BreakpointProvider>();
    return provider?.breakpoint ?? Breakpoint.small;
  }

  @override
  bool updateShouldNotify(covariant BreakpointProvider oldWidget) =>
      oldWidget.breakpoint != breakpoint;
}

class ResponsiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
  });

  Breakpoint _fromWidth(double width) => breakpointFromWidth(width);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.of(context).size;
        final shortSide = constraints.maxWidth == double.infinity
            ? size.shortestSide
            : math.min(constraints.maxWidth, constraints.maxHeight);
        final bp = _fromWidth(shortSide);
        return BreakpointProvider(
          breakpoint: bp,
          child: Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButton: floatingActionButton,
            drawer: drawer,
            bottomNavigationBar: bottomNavigationBar,
          ),
        );
      },
    );
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? small;
  final EdgeInsets? medium;
  final EdgeInsets? large;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.small,
    this.medium,
    this.large,
  });

  @override
  Widget build(BuildContext context) {
    final bp = BreakpointProvider.of(context);
    EdgeInsets? padding;
    switch (bp) {
      case Breakpoint.small:
        padding = small ?? medium ?? large;
        break;
      case Breakpoint.medium:
        padding = medium ?? large ?? small;
        break;
      case Breakpoint.large:
        padding = large ?? medium ?? small;
        break;
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: child,
    );
  }
}

extension BreakpointContextX on BuildContext {
  Breakpoint get breakpoint => BreakpointProvider.of(this);
}
