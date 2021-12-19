import 'dart:math';

import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/announceBloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/widgets/feature_implement_message.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data/raw_data.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/generalModel/announce/news.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';
import 'package:url_launcher/url_launcher.dart';

class MyNewsViews extends StatefulWidget {
  final AnnouncementBloc bloc;

  MyNewsViews({@required this.bloc});

  @override
  _MyNewsListState createState() => _MyNewsListState();
}

class _MyNewsListState extends State<MyNewsViews> {
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
    _futureResult = announcementBloc.getNewsList();
  }

  Future<void> _onRefresh() async {
    return callService();
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

  void _onViews(News news) async {
    _launchURL(news.link);
    final ResponseResult _result =
        await announcementBloc.postView(news.id, "news");

    if (_result.data is Failure) {
      final Failure _f = _result.data;
      _showSncks(_f.responseMessage, true);
      return;
    }
    if (!mounted) return;
    setState(() {
      news.views++;
    });
    _showSncks("Updated", false);
  }

  void _onLikes(News news) async {
    final ResponseResult _result = await announcementBloc.postLike(news.id);

    if (_result.data is Failure) {
      final Failure _f = _result.data;
      _showSncks(_f.responseMessage, true);
      return;
    }
    if (!mounted) return;
    setState(() {
      news.likes++;
    });
    _showSncks("Updated", false);
  }

  @override
  void initState() {
    super.initState();
    announcementBloc = widget.bloc;
    callService();
  }

  void _onPopUpItemSelect(int index) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: primaryColorDark,
      content: SizedBox(height: 30, child: FeatureImplement()),
    ));
  }

  Widget _simplePopup() => PopupMenuButton<int>(
        icon: Icon(
          Icons.more_vert,
          color: Colors.white60,
        ),
        color: Color(0xff171E32),
        onSelected: _onPopUpItemSelect,
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Not interesting",
              style: TextStyle(color: Colors.white),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Copy Link", style: TextStyle(color: Colors.white)),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Share", style: TextStyle(color: Colors.white)),
          ),
        ],
      );

  Widget _buildBody(List<News> data) {
    //print("Data here is:${data}");

    return ListView.separated(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(bottom: minValue * 2),
      itemCount: data.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: Colors.white24),
      itemBuilder: (context, index) {
        News _news = data[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: minValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.network(_news.publisherDetail.icon),
                  // Icon(Icons.access_time),
                  SizedBox(width: 10),
                  Text(_news.publisherDetail.name,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .apply(color: Colors.white54, fontWeightDelta: 1)),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: _simplePopup())),
                  // Expanded(
                  //     child: Align(
                  //         alignment: Alignment.bottomRight,
                  //         child: Icon(Icons.more_vert)))
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: minValue * 1.5,
                ),
                child: GestureDetector(
                  onTap: () => _launchURL(_news.link),
                  //  Chrome.start([_news.link]);

                  child: Text(_news.title,
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
              Text(_news.description,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .apply(color: Colors.white38, fontWeightDelta: 1)),
              SizedBox(
                height: minValue,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _news.newsKeywords.length,
                      itemBuilder: (BuildContext context, int index) {
                        NewsKeywords _newsKeyword = _news.newsKeywords[index];
                        return Padding(
                          padding: EdgeInsets.all(minValue),
                          child: Container(
                              // margin: EdgeInsets.only(left: 5,right: 5),
                              padding: EdgeInsets.all(2),
                              width: 50,
                              height: 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: colorSet[index]),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(_newsKeyword.keyword,
                                      style: TextStyle(color: Colors.white)))),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text("${_news.timePassed}",
                          style: Theme.of(context).textTheme.subtitle.apply(
                                color: Colors.white38,
                                fontWeightDelta: 1,
                              )),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton.icon(
                        onPressed: () => _onLikes(_news),
                        icon: Icon(
                          Icons.thumb_up,
                          color: Colors.white24,
                          size: 20,
                        ),
                        label: Text("${_news.likes} Likes",
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle
                                .apply(
                              color: Colors.white24,
                              fontWeightDelta: 1,
                            ))),
                  ),
                  Expanded(
                    child: FlatButton.icon(
                        onPressed: () => _onViews(_news),
                        icon: Icon(
                          Icons.visibility,
                          color: Colors.white24,
                          size: 20,
                        ),
                        label: Text("${_news.views} views",
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle
                                .apply(
                              color: Colors.white24,
                              fontWeightDelta: 1,
                            ))),
                  ),
                ],
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
      child: Container(
        color: Theme.of(context).primaryColor,
        child: FutureObserver(
          onError: (context, Failure failure) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ResponseFailure(
                  subtitle: failure.responseMessage,
                ),
              ),
            );
          },
          future: _futureResult,
          onWaiting: (context) {
            return MyComponentsLoader();
          },
          onSuccess: (context, List<News> data) {
            //print("News Data:$data");
            //print("News Length:${data.length}");

            return _buildBody(data);
          },
        ),
      ),
    );
  }
}
