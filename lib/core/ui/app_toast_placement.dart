import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Places the overlay against the laid-out footer of the source Scaffold.
class AppToastPlacement extends StatefulWidget {
  const AppToastPlacement({
    required this.child,
    this.sourceContext,
    super.key,
  });

  final Widget child;
  final BuildContext? sourceContext;

  @override
  State<AppToastPlacement> createState() => _AppToastPlacementState();
}

class _AppToastPlacementState extends State<AppToastPlacement> {
  static const _gap = 12.0;
  Element? _scaffold;
  Element? _footer;
  Widget? _footerWidget;
  ValueListenable<ScaffoldGeometry>? _geometry;
  double _footerInset = 0;
  bool _measured = false;
  bool _measurementPending = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleMeasurement();
  }

  void _scheduleMeasurement() {
    if (_measurementPending) return;
    _measurementPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measurementPending = false;
      if (mounted) _measure();
    });
  }

  void _measure() {
    final source = widget.sourceContext;
    if (_scaffold?.mounted != true && source != null && source.mounted) {
      _scaffold = _findScaffold(source as Element);
    }
    final scaffold = _scaffold;
    final footerWidget = scaffold != null && scaffold.mounted
        ? (scaffold.widget as Scaffold).bottomNavigationBar
        : null;
    if (footerWidget != _footerWidget || _footer?.mounted != true) {
      _footerWidget = footerWidget;
      _footer = footerWidget == null
          ? null
          : _findElement(scaffold!, (widget) => widget == footerWidget);
    }
    final footer = _footer;
    final geometry = footer == null ? null : Scaffold.geometryOf(footer);
    if (geometry != _geometry) {
      _geometry?.removeListener(_scheduleMeasurement);
      _geometry = geometry?..addListener(_scheduleMeasurement);
    }

    final overlay = Navigator.of(context, rootNavigator: true).overlay;
    final overlayBox = overlay?.context.findRenderObject();
    final footerBox = footer?.findRenderObject();
    var inset = 0.0;
    if (overlayBox is RenderBox &&
        overlayBox.hasSize &&
        footerBox is RenderBox &&
        footerBox.hasSize) {
      final top =
          overlayBox.globalToLocal(footerBox.localToGlobal(Offset.zero));
      inset = math.max(0, overlayBox.size.height - top.dy);
    }
    if (!_measured || inset != _footerInset) {
      setState(() {
        _measured = true;
        _footerInset = inset;
      });
    }
  }

  Element? _findScaffold(Element source) {
    Element? result;
    source.visitAncestorElements((element) {
      final widget = element.widget;
      if (widget is Scaffold && widget.bottomNavigationBar != null) {
        result = element;
        return false;
      }
      return true;
    });
    return result ??
        _findElement(
            source,
            (widget) =>
                widget is Scaffold && widget.bottomNavigationBar != null);
  }

  Element? _findElement(Element root, bool Function(Widget) matches) {
    if (matches(root.widget)) return root;
    if (root.widget case Offstage(offstage: true)) return null;
    Element? result;
    root.visitChildElements((child) {
      result ??= _findElement(child, matches);
    });
    return result;
  }

  @override
  void dispose() {
    _geometry?.removeListener(_scheduleMeasurement);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = math.max(
      _footerInset,
      MediaQuery.viewInsetsOf(context).bottom +
          MediaQuery.paddingOf(context).bottom,
    );
    return Positioned(
      left: 24,
      right: 24,
      top: 0,
      bottom: bottom + _gap,
      child: Opacity(
        opacity: _measured || widget.sourceContext == null ? 1 : 0,
        child: ClipRect(
          child: SafeArea(
            bottom: false,
            child:
                Align(alignment: Alignment.bottomCenter, child: widget.child),
          ),
        ),
      ),
    );
  }
}
