import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart'
    show Failure;

class StreamMania<T> extends StatelessWidget {
  final Function onError;

  @required
  final Function onSuccess;

  @required
  final Stream stream;

  final Function onWaiting;
  final Function onInitial;
  final Function onFailed;
  final Function
  onGeneralState; // This Builder will be called when data is success but need to approve or set up configuration for device

  /// This is for returning generic type of success data

  StreamMania({this.onGeneralState,
      this.onError,
      this.onSuccess,
      this.stream,
      this.onWaiting,
      this.onFailed,
      this.onInitial})
      : assert(T != null);

  Function get _defaultOnWaiting => (context) => Center(
        child: CircularProgressIndicator(),
      );

  Function get _defaultOnError => (context, Failure error) => Center(
        child: Text("${error.responseMessage}"),
      );

  Function get _defaultInitial => (context) => Center(
        child: Container(),
      );

  Function get _defaultFailed => (context, Failure failure) => Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Text("${failure.responseStatus ?? 'Failed'}"),
              Text("${failure.responseMessage ?? 'Data not available'}"),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
//        //print("Mania Snapshot: ${snapshot.data}");
        if (snapshot.hasError) {
          Failure failure = Failure(
              responseMessage: snapshot.error.toString(),
              responseStatus: "Snapshot error");
          return onError != null
              ? onError(context, failure)
              : _defaultOnError(context, failure);
        }
        if (snapshot.hasData) {
          final Map<dynamic, dynamic> combinedMapData = snapshot.data;

          /// Action State always to be State=>{LOADER, FAILED...}
          final ActionState state = combinedMapData[ActionState];
          assert(state != null);

          if (state == ActionState.INITIAL) {
            return onInitial != null
                ? onInitial(context)
                : _defaultInitial(context);
          } else if (state == ActionState.FAILED) {
            Failure failed = combinedMapData[Failure];
            return onFailed != null
                ? onFailed(context, failed)
                : _defaultFailed(context, failed);
          } else if (state == ActionState.ERROR) {
            Failure failed = combinedMapData[Failure];

            return onError != null
                ? onError(context, failed)
                : _defaultOnError(context, failed);
          } else if (state == ActionState.SUCCESS) {
            /// This is Data and it is dynamic
            final data = combinedMapData[T];
            return onSuccess(context, data);
          } else if (state == ActionState.LOADER) {
            return onWaiting != null
                ? onWaiting(context)
                : _defaultOnWaiting(context);
          } else {
            /// This is Data and it is dynamic
            final data = combinedMapData[T];
            return onGeneralState(context, data, state);
//            return Container(
//              child: Text("$state = Action State isn't defined"),
//            );
          }
        } else {
          return onWaiting != null
              ? onWaiting(context)
              : _defaultOnWaiting(context);
        }
      },
    );
  }
}
