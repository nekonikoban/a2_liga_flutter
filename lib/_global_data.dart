import 'dart:async';
import 'package:flutter/material.dart';

class GlobalData extends ChangeNotifier {
  String _appInfo = '';
  bool _isConnected = false;
  double _refreshRate = 1.0;
  String _teamData = '';

  String get appInfo => _appInfo;
  bool get isConnected => _isConnected;
  double get refreshRate => _refreshRate;
  String get teamData => _teamData;

  void updateAppInfo(appInfo) {
    _appInfo = appInfo;
    notifyListeners();
  }

  String getAppInfo() {
    return _appInfo;
  }

  void updateConnectionStatus(bool isConnected) {
    _isConnected = isConnected;
    notifyListeners();
  }

  bool getConnectionStatus() {
    return _isConnected;
  }

  void updateRefreshRate(double newRefreshRate) {
    _refreshRate = newRefreshRate;
    notifyListeners();
  }

  void updateTeamData(String newTeamData) {
    _teamData = newTeamData;
    notifyListeners();
  }

  double getRefreshRate() {
    return _refreshRate;
  }

  String getTeamData() {
    return _teamData;
  }
}

class GlobalDataStream {
  List<String> initialArray = [];

  List<String> get data => initialArray;

  void updateData(List<String> newArray) {
    initialArray.clear();
    initialArray.addAll(newArray);
    _controller.add(newArray);
  }

  List<String> getData() {
    return initialArray;
  }

  final _controller = StreamController<List<String>>.broadcast();

  Stream<List<String>> get stream => _controller.stream;
}
