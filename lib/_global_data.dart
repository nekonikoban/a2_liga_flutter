import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class GlobalData extends ChangeNotifier {
  bool _isConnected = false;
  double _refreshRate = 1.0;
  String _teamData = '';

  bool get isConnected => _isConnected;
  double get refreshRate => _refreshRate;
  String get teamData => _teamData;

  void addConnectionListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result.index) {
        case 1:
          _isConnected = true;
          break;
        case 2:
          _isConnected = true;
          break;
        case 3:
          _isConnected = true;
          break;
        case 4:
          _isConnected = false;
          break;
        default:
          _isConnected = false;
          break;
      }
      updateConnectionStatus(_isConnected);
    });
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
