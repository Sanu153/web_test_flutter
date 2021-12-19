import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';

class FutureObserver extends StatelessWidget {
  @required
  final Function onError;

  @required
  final Function onSuccess;

  @required
  final Future<ResponseResult> future;

  final Function onWaiting;

  FutureObserver({this.onError, this.onSuccess, this.future, this.onWaiting});

  Function get _defaultOnWaiting => (context) => Center(
        child: CircularProgressIndicator(),
      );

  Function get _defaultOnError => (context, error) => Center(
        child: Text(error),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResponseResult>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<ResponseResult> snapshot) {
//        //print(snapshot.data);
        if (snapshot.hasError)
          return onError(
              context,
              Failure(
                  responseStatus: "internal_error",
                  responseMessage: snapshot.error.toString()));
        if (snapshot.hasData) {
          ResponseResult result = snapshot.data;
          if (result.data is Failure) return onError(context, result.data);
          return onSuccess(context, result.data.data);
        } else {
          return onWaiting != null
              ? onWaiting(context)
              : _defaultOnWaiting(context);
        }
      },
    );
  }
}
