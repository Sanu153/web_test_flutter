import 'package:flutter/material.dart';

class Observer<T> extends StatelessWidget {
  final Function onError;

  @required
  final Function onSuccess;

  @required
  final Stream<T> stream;

  final Function onWaiting;

  Observer({this.onError, this.onSuccess, this.stream, this.onWaiting});

  Function get _defaultOnWaiting => (context) => Center(
        child: CircularProgressIndicator(),
      );

  Function get _defaultOnError => (context, error) => Center(
        child: Text(error),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError)
          return onError != null
              ? onError(context, snapshot.error)
              : _defaultOnError(context, snapshot.error);
        if (snapshot.hasData) {
          return onSuccess(context, snapshot.data);
        } else {
          return onWaiting != null
              ? onWaiting(context)
              : _defaultOnWaiting(context);
        }
      },
    );
  }
}
