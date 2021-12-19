import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customViews/dialog/custom_dialog_views.dart';

class MyCustomAlertDialog extends StatelessWidget {
  const MyCustomAlertDialog({
    Key key,
    @required this.title,
    this.titlePadding = const EdgeInsets.only(bottom: 0, top: 8),
    this.titleTextStyle,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.contentTextStyle,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.minWidth,
    this.shape,
  })  : assert(contentPadding != null),
        super(key: key);

  final Widget title;

  final double minWidth;

  final EdgeInsetsGeometry titlePadding;

  final TextStyle titleTextStyle;

  final Widget content;

  final EdgeInsetsGeometry contentPadding;

  final TextStyle contentTextStyle;

  final List<Widget> actions;

  final Color backgroundColor;

  final double elevation;

  final String semanticLabel;

  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    final dialogWidth = MediaQuery.of(context).size.width * 2 / 2;

    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final DialogTheme dialogTheme = DialogTheme.of(context);
    final List<Widget> children = <Widget>[];
    String label = semanticLabel;

    if (title != null) {
      children.add(Padding(
        padding: titlePadding ??
            EdgeInsets.fromLTRB(24.0, 24.0, 24.0, content == null ? 20.0 : 0.0),
        child: title,
      ));
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          label = semanticLabel ??
              MaterialLocalizations.of(context)?.alertDialogLabel;
      }
    }

    if (content != null) {
      children.add(Flexible(
        child: Padding(
          padding: contentPadding,
          child: DefaultTextStyle(
            style: contentTextStyle ??
                dialogTheme.contentTextStyle ??
                theme.textTheme.subhead,
            child: content,
          ),
        ),
      ));
    }

    if (actions != null) {
      children.add(ButtonTheme.bar(
        child: ButtonBar(
          children: actions,
        ),
      ));
    }

    Widget dialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    if (label != null)
      dialogChild = Semantics(
        namesRoute: true,
        label: label,
        child: dialogChild,
      );

    return MyCustomDialog(
      child: dialogChild,
      minWidth: minWidth != null ? minWidth : dialogWidth - 52,
      padding: titlePadding,
      backgroundColor: backgroundColor,
      alignment: Alignment.center,
    );
  }
}
