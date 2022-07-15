import 'package:flutter/material.dart';

typedef ShouldRebuildFunction<T> = bool Function(T oldWidget, T newWidget);

class ShouldRebuild<T extends Widget> extends StatefulWidget {
  final T child;
  final ShouldRebuildFunction<T>? shouldRebuild;

  const ShouldRebuild({
    Key? key,
    required this.child,
    this.shouldRebuild,
  }) : super(key: key);

  @override
  _ShouldRebuildState createState() => _ShouldRebuildState<T>();
}

class _ShouldRebuildState<T extends Widget> extends State<ShouldRebuild> {
  @override
  ShouldRebuild<T> get widget => super.widget as ShouldRebuild<T>;
  T? oldWidget;

  @override
  Widget build(BuildContext context) {
    final T newWidget = widget.child;
    if (oldWidget == null ||
        (widget.shouldRebuild == null
            ? true
            : widget.shouldRebuild!(oldWidget!, newWidget))) {
      oldWidget = newWidget;
    }
    return oldWidget as T;
  }
}
