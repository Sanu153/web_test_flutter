import 'dart:async';

import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';

class SideBarBloc {
  final DataManager dataManager;

  SideBarBloc({this.dataManager}) {
    updateTime();
  }

  final BehaviorSubject<bool> _sidebarUpdatedSubject =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<String> _currentDateTimeSubject =
      BehaviorSubject<String>.seeded('');

  Observable<bool> get sideBarIconUpdate$ => _sidebarUpdatedSubject.stream;

  Observable<String> get currentDateTime$ => _currentDateTimeSubject.stream;

  void updateTime() {
    Timer(Duration(seconds: 1), () {
      final format = DateFormat("dd MMM, yy, H:m:s");
      String formated = format.format(DateTime.now());
      _currentDateTimeSubject.sink.add(formated);

      updateTime();
    });
  }

  void updateIcon() {
    _sidebarUpdatedSubject.add(true);
  }

  void resetIcon() {
    _sidebarUpdatedSubject.add(false);
  }

  void dispose() {
    _sidebarUpdatedSubject.close();
  }

  void getAnnounceMents() {}
}
