import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/announceBloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/generalModel/announce/events.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';
import 'package:url_launcher/url_launcher.dart';

class MyEventList extends StatefulWidget {
  final AnnouncementBloc bloc;

  MyEventList({@required this.bloc});

  @override
  _MyEventListState createState() => _MyEventListState();
}

class _MyEventListState extends State<MyEventList> {
  final double minValue = 8.0;

  AnnouncementBloc announcementBloc;
  Future<ResponseResult> _futureResult;

  void callService() async {
    _futureResult = announcementBloc.getEventsList();
  }

  Future<void> _onRefresh() async {
    return callService();
  }

  void _onViews(Events tender) async {
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

  Widget _buildBody(List<Events> data) {
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
      itemCount: data.length,
      padding: EdgeInsets.only(bottom: minValue * 2, top: minValue),
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: Colors.white24),
      itemBuilder: (context, index) {
        Events _event = data[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: minValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: minValue,
                    backgroundImage: NetworkImage(
                      _event.publisherDetail.icon,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("${_event.publisherDetail.name}", style: caption),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.cloud_download,
                            color: greenColor,
                            size: 20,
                          )))
                ],
              ),
              // SizedBox(height: 8.0,),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: minValue),
                child: GestureDetector(
                  onTap: () => _onViews(_event),
                  //  Chrome.start([_news.link]);

                  child: Text("${_event.title}", style: body2),
                ),
              ),
              // SizedBox(height: 5.0,),
              Row(
                children: <Widget>[
                  Text("Venue:", style: caption),
                  SizedBox(width: 5),
                  Text("${_event.venue}", style: body2),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Text(" Date:", style: caption),
                        SizedBox(width: 4),
                        Text("${_event.dateTime.split("T")[0]}", style: body2)
                      ],
                    ),
                  )),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "Description:",
                style: caption.apply(color: Colors.white60),
              ),
              SizedBox(
                height: 3,
              ),
              Text("${_event.description}", style: caption),
              Container(
                height: 20,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.visibility,
                      color: Colors.white24,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("${_event.views}", style: caption)
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
        onSuccess: (context, List<Events> data) {
          //print("News Data:$data");
          //print("News Length:${data.length}");

          return _buildBody(data);
        },
      ),
    );
  }
}
