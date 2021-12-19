import 'dart:math';

import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/announceBloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data/raw_data.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/generalModel/announce/tenders.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTenderList extends StatefulWidget {
  final AnnouncementBloc bloc;

  MyTenderList({@required this.bloc});

  @override
  _MyTenderListState createState() => _MyTenderListState();
}

class _MyTenderListState extends State<MyTenderList> {
  final double minValue = 8.0;

  AnnouncementBloc announcementBloc;
  Future<ResponseResult> _futureResult;

  Random random = Random();
  int index = 0;

  //randomly generating the color
  void changeIndex() {
    setState(() => index = random.nextInt(5));
  }

  Future<void> callService() async {
    _futureResult = announcementBloc.getTendersList();
  }

  Future<void> _onRefresh() async {
    return callService();
  }

  void _onViews(Tenders tender) async {
    _launchURL(tender.link);
    final ResponseResult _result =
        await announcementBloc.postView(tender.id, "tender");

    if (_result.data is Failure) {
      final Failure _f = _result.data;
      _showSncks(_f.responseMessage, true);
      return;
    }
    if (!mounted) return;
    setState(() {
      tender.views++;
    });
    _showSncks("Updated", false);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showSncks("Could not launch $url", true);
    }
  }

  _showSncks(String msg, bool hasError) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: hasError ? redColor : greenColor,
      content: Text(
        "$msg",
        style: TextStyle(color: Colors.white),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    announcementBloc = widget.bloc;
    callService();
  }

  Widget _buildBody(List<Tenders> data) {
    final caption = Theme.of(context).textTheme.caption.apply(
          color: Colors.white38,
          fontWeightDelta: 1,
        );

    final body2 = Theme.of(context).textTheme.body2.apply(
          color: Colors.white70,
          fontWeightDelta: 1,
        );

    return ListView.separated(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(bottom: minValue * 2, top: minValue),
      itemCount: data.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: Colors.white24),
      itemBuilder: (context, index) {
        Tenders _tender = data[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: minValue),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: minValue,
                    backgroundImage: NetworkImage(
                      _tender.publisherDetail.icon,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(_tender.publisherDetail.name,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .apply(color: Colors.white54, fontWeightDelta: 1)),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.cloud_download,
                            size: 20,
                            color: greenColor,
                          )))
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: minValue),
                child: GestureDetector(
                  onTap: () => _onViews(_tender),
                  child: Text(_tender.title,
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle
                          .apply(
                        color: Colors.white70,
                        fontWeightDelta: 1,
                      )),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        Text("Product:", style: caption),
                        SizedBox(width: 10),
                        Text("${_tender.product}", style: body2),
                      ],
                    ),
                  ),
                  Flexible(
                      child: Row(
                    children: <Widget>[
                      Text("Opening Date:", style: caption),
                      Text("${_tender.openingDate}", style: body2)
                    ],
                  )),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        Text("Quantity:", style: caption),
                        SizedBox(width: 10),
                        Text("${_tender.quantity}", style: body2),
                      ],
                    ),
                  ),
                  Flexible(
                      child: Row(
                    children: <Widget>[
                      Text("Due Date:", style: caption),
                      SizedBox(width: 10),
                      Text("${_tender.dueDate}", style: body2)
                    ],
                  )),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(children: <Widget>[
                  Text("Location:", style: caption),
                  SizedBox(width: 10),
                  Text("${_tender.location}", style: body2),
                  SizedBox(
                    width: 18,
                  ),
                ]),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                      width: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _tender.tendersKeywords.length,
                        itemBuilder: (BuildContext context, int index) {
                          TendersKeywords _tenderKeyword =
                              _tender.tendersKeywords[index];
                          return Container(
                              width: 50,
                              height: 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: colorSet[index]),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(_tenderKeyword.keyword)));
                        },
                      ),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.visibility,
                      color: Colors.white24,
                    ),
                    SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text("${_tender.views}",
                          style: Theme.of(context).textTheme.subtitle.apply(
                                color: Colors.white24,
                                fontWeightDelta: 1,
                              )),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: FutureObserver(
        onError: (context, Failure failure) {
          return Center(
            child: ResponseFailure(
              subtitle: failure.responseMessage,
            ),
          );
        },
        future: _futureResult,
        onWaiting: (context) {
          return MyComponentsLoader();
        },
        onSuccess: (context, List<Tenders> data) {
          return _buildBody(data);
        },
      ),
    );
  }
}
