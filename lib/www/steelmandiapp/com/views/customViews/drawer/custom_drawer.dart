import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// The possible alignments of a [Drawer].
enum DrawerAlignment {
  start,
  end,
}

const double _kWidth = 380.0;
const double _kEdgeDragWidth = 20.0;
const double _kMinFlingVelocity = 365.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

class MyCustomDrawer extends StatelessWidget {
  const MyCustomDrawer ({
    Key key,
    this.elevation = 16.0,
    this.child,
    this.semanticLabel,
  })
      : assert(elevation != null && elevation >= 0.0),
        super(key: key);
  final double elevation;

  final Widget child;

  final String semanticLabel;

  @override
  Widget build (BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    String label = semanticLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        label = semanticLabel;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        label = semanticLabel ?? MaterialLocalizations
            .of(context)
            ?.drawerLabel;
    }
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: _kWidth),
        child: Material(
          elevation: elevation,
          child: child,
        ),
      ),
    );
  }
}
