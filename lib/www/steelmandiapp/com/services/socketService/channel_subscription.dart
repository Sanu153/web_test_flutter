import 'package:action_cable/action_cable.dart';

class Subscription {
  final ActionCable cable;

  Subscription({this.cable});

  static final String BUY_SELL_COUNT_CHANNEL = 'BuySellCountChannel';

  void subscribeBuySellCount(
      {Map<String, dynamic> channelParams,
      Function onSubscribed,
      Function onData}) async {
    cable.subscribeToChannel(BUY_SELL_COUNT_CHANNEL,
        channelParams: channelParams,
        onSubscribed: onSubscribed,
        onMessage: onData);
  }

  void unSubscribeBuySellCount() =>
      cable.unsubscribeToChannel(BUY_SELL_COUNT_CHANNEL);
}
