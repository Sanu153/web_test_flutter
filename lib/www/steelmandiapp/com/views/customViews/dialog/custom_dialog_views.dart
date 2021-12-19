// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyCustomDialog extends StatelessWidget {
  const MyCustomDialog({
    Key key,
    this.child,
    this.elevation,
    this.minWidth = 280.0,
    this.backgroundColor,
    this.shape,
    this.padding,
    this.alignment = Alignment.topLeft,
    this.insetAnimationDuration = const Duration(milliseconds: 300),
    this.insetAnimationCurve = Curves.decelerate,
  }) : super(key: key);

  final Widget child;
  final double minWidth;
  final Color backgroundColor;
  final double elevation;
  final ShapeBorder shape;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;

  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;

  Color _getColor(BuildContext context) {
    return Theme.of(context).secondaryHeaderColor;
  }

  static const RoundedRectangleBorder _defaultDialogShape =
  RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)));
  static const double _defaultElevation = 24.0;

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);

    //print("Printing From Dialog COntext");
    return new AnimatedPadding(
      padding: MediaQuery
          .of(context)
          .viewInsets + padding,
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: new MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: new Align(
          alignment: alignment,
          child: new ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: new Material(
              color: backgroundColor != null
                  ? backgroundColor
                  : Theme
                  .of(context)
                  .secondaryHeaderColor,
              elevation: elevation != null ? elevation : _defaultElevation,
              shape: shape != null ? shape : _defaultDialogShape,
              type: MaterialType.card,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomSimpleDialogForProduct extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  const MyCustomSimpleDialogForProduct(
      {Key key, @required this.child, @required this.padding});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new MyCustomDialog(child: child, padding: padding);
  }
}

class MyCustomBuySellDialog extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final double elevation;
  final double minWidth;
  final Color backgroundColor;

  const MyCustomBuySellDialog({Key key,
    @required this.child,
    @required this.padding,
    @required this.alignment,
    this.backgroundColor,
    this.elevation = 8.0,
    this.minWidth = 280.0});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new MyCustomDialog(
      child: child,
      padding: padding ?? EdgeInsets.all(8.0),
      alignment: alignment,
      elevation: elevation,
      minWidth: minWidth,
      backgroundColor: backgroundColor,
    );
  }
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return new FadeTransition(
    opacity: new CurvedAnimation(
      parent: animation,
//      curve: Curves.easeInCubic,
      curve: Curves.bounceInOut,
//      curve: Curves.easeInOutBack,
//      curve: Curves.,
    ),
    child: child,
  );
}

Future<T> showCustomDialog<T>({
  @required
      BuildContext context,
  bool barrierDismissible = true,
  @Deprecated(
      'Instead of using the "child" argument, return the child from a closure '
      'provided to the "builder" argument. This will ensure that the BuildContext '
      'is appropriate for widgets built in the dialog.')
      Widget child,
  WidgetBuilder builder,
}) {
  assert(child == null || builder == null);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
      final Widget pageChild = child ?? new Builder(builder: builder);
      return new SafeArea(
        child: new Builder(builder: (BuildContext context) {
          return theme != null
              ? new Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black12,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: _buildMaterialDialogTransitions,
  );
}
