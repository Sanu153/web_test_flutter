import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/widgets/text_field.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/nego_number_key_pad.dart';

class MyBottomFilter extends StatefulWidget {
  final Negotiation negotiation;

  MyBottomFilter({this.negotiation});

  @override
  _MyBottomFilterState createState() => _MyBottomFilterState();
}

class _MyBottomFilterState extends State<MyBottomFilter> {
  final double minValue = 8.0;

  double _quantity;
  double _price;
  int _payment;
  int _delivery;

  int _currentIndex = -1;

//  final Color activeColor = filterBackground;

  bool isInitial = true;

  PortfolioBloc _portfolioBloc;

  @override
  void initState() {
    super.initState();
    _quantity = widget.negotiation.quantity;
    _price = widget.negotiation.pricePerUnit;
    _payment = widget.negotiation.paymentsInDays;
    _delivery = widget.negotiation.deliveryInDays;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _portfolioBloc = Provider.of(context).fetch(PortfolioBloc);
  }

  void _onPadClose() {
    setState(() {
      if (!isInitial) {
        isInitial = true;
        _currentIndex = -1;
      }
    });
  }

  void _decrement() {}

  void _increment() {}

  String result = '';

  void _onDataChanged(String value) {
//    //print(value);
    if (value.isEmpty) {
      return;
    }
    if (result.isEmpty && value == '.') {
      return;
    }
//    final double _value = double.parse(value);
    if (_currentIndex == 0) {
      setState(() {
        if (value == 'C') {
          _price = 0.0;
          result = '';
          return;
        }
        if (value == 'INCREMENT') {
          _price++;
          return;
        } else if (value == 'DECREMENT') {
          _price--;
          return;
        }
        result = result + value;
        _price = double.parse(result);
      });
    } else if (_currentIndex == 1) {
      setState(() {
        if (value == 'C') {
          _quantity = 0.0;
          result = '';
          return;
        }
        if (value == 'INCREMENT') {
          _quantity++;
          return;
        } else if (value == 'DECREMENT') {
          _quantity--;
          return;
        }
        result = result + value;
        _quantity = double.parse(result);
      });
    } else if (_currentIndex == 2) {
      if (result.length > 5) return;

      setState(() {
        if (value == 'C') {
          _payment = 0;
          result = '';
          return;
        }
        if (value == 'INCREMENT') {
          _payment++;
          return;
        } else if (value == 'DECREMENT') {
          _payment--;
          return;
        }
        result = result + value;
        _payment = int.parse(result);
      });
    } else if (_currentIndex == 3) {
      if (result.length > 5) return;
      setState(() {
        if (value == 'C') {
          _delivery = 0;
          result = '';
          return;
        }
        if (value == 'INCREMENT') {
          _delivery++;
          return;
        } else if (value == 'DECREMENT') {
          _delivery--;
          return;
        }
        result = result + value;

        _delivery = int.parse(result);
      });
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
      result = '';

      if (isInitial) {
        isInitial = false;
      }
    });
  }

  void _onKeyboardMsgSave(String msg) async {
    //print("Normal : $msg");
    if (msg.isEmpty) return;
    await _portfolioBloc.makeNegotiation(
      null,
      msg,
      widget.negotiation.requestResponderId,
    );
  }

  void _onSend() async {
    _onPadClose();
    // Block Repeating Value
    Negotiation lastNegotiation = _portfolioBloc.lastNegotiationValue();

    /// First Value In The List
    NegotiationListItem firstChatItem =
        _portfolioBloc.firstNegotiationStreamValue;

    if (lastNegotiation == null || lastNegotiation.requestResponderId == null)
      return;
    if (lastNegotiation.requestResponderId ==
        widget.negotiation.requestResponderId) {
      // LoggedIn User Can not Send Same Value Again Only
      // If The First Object Is Negotiation Object not A Message Object
      if (firstChatItem is Negotiation) {
        if (_price == lastNegotiation.pricePerUnit &&
            _quantity == lastNegotiation.quantity &&
            _delivery == lastNegotiation.deliveryInDays &&
            _payment == lastNegotiation.paymentsInDays) {
          //print("Same Value Can not be Send Again");
          return;
        }
      }
    }

    Negotiation negotiation = Negotiation(
        requestResponderId: widget.negotiation.requestResponderId,
        pricePerUnit: _price,
        deliveryInDays: _delivery,
        quantity: _quantity,
        paymentsInDays: _payment);
    await _portfolioBloc.makeNegotiation(
        negotiation, null, widget.negotiation.requestResponderId);
  }

  Widget _buildInitial() {
    final Color activeColor = Theme.of(context).primaryColor;
    final resultActive =
        Theme.of(context).textTheme.subtitle.apply(color: Colors.white);
    final title =
        Theme.of(context).textTheme.caption.apply(color: Colors.white54);

    final resultInActive =
        Theme.of(context).textTheme.subtitle.apply(color: Colors.white60);
    final titleInActive =
        Theme.of(context).textTheme.caption.apply(color: Colors.white38);

    final borderColor = Theme.of(context).primaryColor;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(minValue),
          topRight: Radius.circular(minValue)),
      child: Container(
        height: 55.0,
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
//                          border: Border(
//                              bottom:
//                                  BorderSide(color: borderColor, width: 1.0))
        ),
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Container()
            : Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(color: borderColor, width: 1.0))),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: borderColor,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MyTextFieldViews(
                                          onSave: _onKeyboardMsgSave,
                                        ))),
                            child: Icon(
                              Icons.keyboard,
                              size: minValue * 4,
                              color: Colors.white70,
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                          color: _currentIndex == 0 ? activeColor : null,
                          border: Border(
                              right:
                                  BorderSide(color: borderColor, width: 1.0))),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: borderColor,
                          onTap: () => _onTap(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "${_price}",
                                style: _currentIndex == 0
                                    ? resultActive
                                    : resultInActive,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Price",
                                style: title,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                          color: _currentIndex == 1 ? activeColor : null,
                          border: Border(
                              right:
                                  BorderSide(color: borderColor, width: 1.0))),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: borderColor,
                          onTap: () => _onTap(1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "${_quantity} T",
                                style: _currentIndex == 1
                                    ? resultActive
                                    : resultInActive,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Quantity",
                                style: title,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                          color: _currentIndex == 2 ? activeColor : null,
                          border: Border(
                              right:
                                  BorderSide(color: borderColor, width: 1.0))),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: borderColor,
                          onTap: () => _onTap(2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "${_payment} D",
                                style: _currentIndex == 2
                                    ? resultActive
                                    : resultInActive,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Payment",
                                style: title,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                        color: _currentIndex == 3 ? activeColor : null,
//                                  border: Border(
//                                      right: BorderSide(
//                                          color: borderColor, width: 1.0))
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: borderColor,
                          onTap: () => _onTap(3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "${_delivery} D",
                                style: _currentIndex == 3
                                    ? resultActive
                                    : resultInActive,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Delivery",
                                style: title,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
//                          Expanded(
//                            flex: 2,
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                              children: <Widget>[
//                                Text(
//                                  "${widget.price * widget.quantitley} L",
//                                  style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
//                                  overflow: TextOverflow.ellipsis,
//                                  textAlign: TextAlign.center,
//                                ),
//                                Text(
//                                  "Total",
//                                  style: resultActive,
//                                ),
//                              ],
//                            ),
//                          ),
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
//                color: Colors.lightBlue[700],
                      child: Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                            height: double.maxFinite,
                            child: RaisedButton(
                              child: Icon(
                                Icons.send,
                                size: minValue * 4,
                                color: Colors.white70,
                              ),
                              onPressed: () => _onSend(),
                              elevation: 0.0,
                              color: chatTileOne,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    final activeStyle = Theme.of(context).textTheme
//    final Color activeColor = Theme.of(context).primaryColor;

    return isInitial
        ? _buildInitial()
        : ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(minValue),
                topRight: Radius.circular(minValue)),
            child: Container(
              height: 250.0,
              decoration: BoxDecoration(
                color: filterBackground,
              ),
              child: MediaQuery.of(context).orientation != Orientation.landscape
                  ? Container()
                  : Column(
                      children: <Widget>[
                        _buildInitial(),
                        Expanded(
                          child: MyNegotiateNumberKeyPad(
                            decrement: () => _onDataChanged('DECREMENT'),
                            increment: () => _onDataChanged('INCREMENT'),
                            onDataChanged: _onDataChanged,
                            onClose: _onPadClose,
                          ),
                        )
                      ],
                    ),
            ),
          );
  }
}
