import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '_globals.dart';

class GlobalData extends ChangeNotifier {
  //SINGLETON
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() => _instance;

  GlobalData._internal();

  String _appInfo = '';
  String _downloadLink = '';
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

  void updateDownloadLink(downloadLink) {
    _downloadLink = downloadLink;
    notifyListeners();
  }

  String getDownloadLink() {
    return _downloadLink;
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
