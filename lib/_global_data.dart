import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalData extends ChangeNotifier {
  //SINGLETON
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() {
    _instance._loadMainThemeColor(); // LOAD CANVAS COLOR IN CONSTRUCTOR
    _instance._loadAppBarTitle(); // LOAD APP BAR TITLE
    return _instance;
  }

  GlobalData._internal();

  Color _mainThemeColor = const Color.fromARGB(255, 6, 54, 108);
  final mainThemeColorCode = '4278597228';
  static const String _mainThemeColorKey = 'canvasColor';
  static const String _appBarTitleKey = '__myteam__';
  String _appBarTitle = 'STATS';
  String _appInfo = '';
  String _downloadLink = '';
  bool _isConnected = false;
  double _refreshRate = 1.0;
  String _teamData = '';

  Color get mainThemeColor => _mainThemeColor;
  String get appBarTitle => _appBarTitle;
  String get appInfo => _appInfo;
  bool get isConnected => _isConnected;
  double get refreshRate => _refreshRate;
  String get teamData => _teamData;

  set mainThemeColor(Color value) {
    _mainThemeColor = value;
    saveMainThemeColor(value);
    notifyListeners();
  }

  Future<void> saveMainThemeColor(Color value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_mainThemeColorKey, value.value);
  }

  Future<void> _loadMainThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_mainThemeColorKey);
    if (colorValue != null) {
      _mainThemeColor = Color(colorValue);
      notifyListeners();
    }
  }

  /* void _restartApp() {
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
  } */

  set appBarTitle(String title) {
    _appBarTitle = title;
    notifyListeners();
  }

  Future<void> saveAppBarTitle(String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appBarTitleKey, title);
  }

  Future<void> _loadAppBarTitle() async {
    final prefs = await SharedPreferences.getInstance();
    final titleValue = prefs.getString(_appBarTitleKey);
    if (titleValue != null) {
      _appBarTitle = titleValue;
      notifyListeners();
    }
  }

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
