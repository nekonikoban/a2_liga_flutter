import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '_global_data.dart';
import '_globals.dart';
import 'custom-widgets/bounce_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  final GlobalData globalData;
  final List<String> array;
  const SettingsScreen(
      {Key? key, required this.globalData, required this.array})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final globals = Globals();

  late AnimationController controller;

  String appVersion = '';

  List<String> array = [];
  List<String> arrayImages = [];
  String myTeam = '';
  String myTeamData = '';

  bool isTeamSaved = false;

  bool isBosniaTapped = false;
  bool isAmericaTapped = false;

  bool switchNotifications = false;
  bool switchCache = true;

  double _sliderRefreshRateValue = 1.0;

  @override
  void initState() {
    super.initState();
    //LOAD NOTIFICATIONS SWITCH STATE
    globals
        .getFromCacheByKey('__switch__notifications')
        .then((cacheNotifications) => {
              if (cacheNotifications.isNotEmpty && cacheNotifications != 'null')
                setState(() => {
                      switchNotifications =
                          cacheNotifications == 'true' ? true : false
                    })
            });
    //LOAD CACHE SWITCH STATE
    globals.getFromCacheByKey('__switch__cache').then((cacheSwitch) => {
          if (cacheSwitch.isNotEmpty && cacheSwitch != 'null')
            setState(() => {switchCache = cacheSwitch == 'true' ? true : false})
        });
    //LOAD MY TEAM STATE
    globals.getFromCacheByKey('__myteam__').then((cacheMyTeam) => {
          if (cacheMyTeam.isNotEmpty && cacheMyTeam != 'null')
            setState(() => {myTeam = cacheMyTeam})
        });
    //INIT CLUB IMAGES
    arrayImages = globals.initTeamImages(arrayImages);
    //LISTEN TO CONNECTION CHANGE
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      widget.globalData
          .updateConnectionStatus(result != ConnectivityResult.none);
      if (!widget.globalData.isConnected) {
        globals.showMessage('NO INTERNET'.tr());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int assignClubNameToInteger(clubName) {
    for (int i = 0; i < arrayImages.length; i++) {
      if (arrayImages[i] == clubName) return i;
    }
    return 0;
  }

  Future turnOnNotifications() async {
    setState(() => {switchNotifications = true});
  }

  Future changeLanguage() async {
    var currentLocale = context.locale.toString().split('_');
    if (currentLocale[0] == 'bs') {
      context.setLocale(const Locale('en', 'US'));
      showToast('CHANGE SUCCESSFUL'.tr(), textStyle: globals.textStyleSchedule);
      setState(() => {isAmericaTapped = true, isBosniaTapped = false});
    } else {
      context.setLocale(const Locale('bs', 'BA'));
      showToast('PROMJENA USPJESNA'.tr(), textStyle: globals.textStyleSchedule);
      setState(() => {isAmericaTapped = false, isBosniaTapped = true});
    }
  }

  //DISCLAIMER DIALOG
  showDialogDisclaimer(context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: globals.mainColor.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                    width: 0, color: Color.fromARGB(255, 45, 6, 108)),
              ),
              content: SingleChildScrollView(
                  child: Center(
                      child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Disclaimer'.tr(),
                        style: TextStyle(
                            fontFamily: globals.fontFam, color: Colors.white)),
                  ],
                ),
                globals.devider20,
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Text(
                          globals.disclaimerText.tr(),
                          textAlign: TextAlign.justify,
                          style: globals.textStyleSchedule,
                        ))),
                globals.devider20,
              ]))),
            );
          });
        });
  }

  //INFO DIALOG
  showDialogInfo(context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: globals.mainColor.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                    width: 0, color: Color.fromARGB(255, 45, 6, 108)),
              ),
              content: SingleChildScrollView(
                  child: Center(
                      child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Info'.tr(),
                        style: TextStyle(
                            fontFamily: globals.fontFam, color: Colors.white)),
                  ],
                ),
                globals.devider20,
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Text(
                          '${globals.infoUsage.tr()}\n\n\n${globals.infoText.tr()}',
                          textAlign: TextAlign.justify,
                          style: globals.textStyleSchedule,
                        ))),
                globals.devider20,
              ]))),
            );
          });
        });
  }

  //MY TEAM DIALOG
  showMyTeamDialog(context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: globals.mainColor.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                    width: 0, color: Color.fromARGB(255, 45, 6, 108)),
              ),
              content: SingleChildScrollView(
                  child: Center(
                      child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('MY TEAM'.tr(),
                        style: TextStyle(
                            fontFamily: globals.fontFam, color: Colors.white)),
                  ],
                ),
                globals.devider20,
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < arrayImages.length; i++)
                          Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: globals.mainColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: GestureDetector(
                                    child: Image.asset(
                                        'assets/${arrayImages[i]}.png'),
                                    onTap: () async => {
                                          myTeam = arrayImages[i],
                                          isTeamSaved =
                                              await globals.setToCacheByKey(
                                                  '__myteam__', myTeam),
                                          Navigator.of(context).pop(),
                                          if (isTeamSaved)
                                            {
                                              //TURN NOTIFICAIONS
                                              await turnOnNotifications(),
                                              //SHOW SUCCESS MSG
                                              showToast(
                                                  '${'Notifications on for'.tr()} $myTeam'),
                                              //PUSH NOTIFICATIONS
                                              await globals.notificationPush(
                                                  '${'Following'.tr()} $myTeam',
                                                  'You will be notified when changes occur'
                                                      .tr(),
                                                  assignClubNameToInteger(
                                                          myTeam)
                                                      .toString(),
                                                  assignClubNameToInteger(
                                                          myTeam)
                                                      .toString(),
                                                  NotificationLayout.Inbox),
                                              await globals.setToCacheByKey(
                                                  '__switch__notifications',
                                                  isTeamSaved),
                                              await globals.setToCacheByKey(
                                                  '__my_team_data__',
                                                  getMyTeamData(myTeam))
                                            }
                                          else
                                            showToast(
                                                'Could not cache data'.tr())
                                        })),
                          )
                      ],
                    )),
                globals.devider20,
              ]))),
            );
          });
        });
  }

  String getMyTeamData(myTeam) {
    String data = '';
    for (int i = 0; i < globals.numOfTeams; i++) {
      if (myTeam == widget.array[i].split(',')[1]) {
        data = widget.array[i];
      }
    }
    return data;
  }

  //Latest App DIALOG
  showRefreshRateDialog(context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: globals.mainColor.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                    width: 0, color: Color.fromARGB(255, 45, 6, 108)),
              ),
              content: SingleChildScrollView(
                  child: Center(
                      child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Latest App'.tr(),
                        style: TextStyle(
                            fontFamily: globals.fontFam, color: Colors.white)),
                  ],
                ),
                globals.devider20,
                Text(
                    '${_sliderRefreshRateValue.toStringAsFixed(0)} ${'hr'.tr()}',
                    style: const TextStyle(color: Colors.white)),
                Slider(
                  divisions: 24,
                  min: 1,
                  max: 24,
                  value: _sliderRefreshRateValue,
                  onChanged: (newValue) {
                    setState(() {
                      _sliderRefreshRateValue = newValue;
                    });
                  },
                ),
                //SAVE TO CACHE
                ElevatedButton(
                    onPressed: () async => {
                          await globals.setToCacheByKey(
                              '__refresh_rate__', _sliderRefreshRateValue),
                          Navigator.of(context).pop(),
                          Provider.of<GlobalData>(context, listen: false)
                              .updateRefreshRate(_sliderRefreshRateValue)
                        },
                    style: globals.elevatedBtnStyle,
                    child: Text("SAVE".tr(),
                        style: TextStyle(fontFamily: globals.fontFam))),
                globals.devider20,
              ]))),
            );
          });
        });
  }

  //DOWNLOAD DIALOG (UPDATED APK)
  showDownloadDialog(context, appData) async {
    await showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: globals.mainColor.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                    width: 0, color: Color.fromARGB(255, 45, 6, 108)),
              ),
              content: SingleChildScrollView(
                  child: Center(
                      child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Latest App'.tr(),
                        style: TextStyle(
                            fontFamily: globals.fontFam, color: Colors.white)),
                  ],
                ),
                for (int i = 0; i < 2; i++) globals.devider20,
                Center(
                  child: appData.isEmpty
                      ? Text(
                          '${'You have the latest version'.tr()} $appVersion',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center)
                      : Text('Updated version is available!'.tr(),
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                ),
                //SAVE TO CACHE
                ElevatedButton(
                    onPressed: () async => {
                          if (appData.isEmpty)
                            {Navigator.of(context).pop()}
                          else
                            {launchUrl(appData)}
                        },
                    style: globals.elevatedBtnStyle,
                    child: Text(appData.isEmpty ? "OK".tr() : "DOWNLOAD".tr(),
                        style: TextStyle(fontFamily: globals.fontFam))),
                globals.devider20,
              ]))),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: Center(
            child: SingleChildScrollView(
                child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Language'.tr(), style: globals.textStyleSchedule),
        globals.devider20,
        //CHANGE LOCALIZATION
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //BOSNIAN FLAG
              GestureDetector(
                  child: Image.asset('assets/flags/ba.png',
                      width: MediaQuery.of(context).size.width / 5),
                  onTap: () async =>
                      {isBosniaTapped ? null : await changeLanguage()}),
              //DEVIDER
              globals.devider20,
              //AMERICAN FLAG
              GestureDetector(
                  child: Image.asset('assets/flags/us.png',
                      width: MediaQuery.of(context).size.width / 5),
                  onTap: () async =>
                      {isAmericaTapped ? null : await changeLanguage()})
            ]),
        //DEVIDER
        globals.devider20,
        //NOTIFICATIONS SWITCH
        SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Turn on notifications'.tr(),
                    style: globals.textStyleSchedule),
                globals.devider20,
                Switch(
                  value: switchNotifications,
                  onChanged: (value) {
                    if (myTeam.isEmpty || myTeam == 'null') {
                      showToast('Choose your club first'.tr(),
                          textStyle: globals.textStyleSchedule);
                    }
                    //setState(() => {switchNotifications = value});
                  },
                ),
              ],
            )),
        //DEVIDER
        globals.devider20,
        //CACHE SWITCH
        SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Turn on cache'.tr(), style: globals.textStyleSchedule),
                globals.devider20,
                Switch(
                  value: switchCache,
                  onChanged: (value) async {
                    setState(() => {switchCache = value});
                    await globals.setToCacheByKey('__switch__cache', value);
                  },
                ),
              ],
            )),
        for (int i = 0; i < 2; i++) globals.devider20,
        //MY TEAM
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BounceButton(
              text: 'Download'.tr(),
              color: Colors.blue,
              icon: const Icon(Icons.download_outlined),
              onPressed: () async => {
                if (widget.globalData.isConnected)
                  {
                    print(
                        "widget.globalData.appInfo.isNotEmpty => ${widget.globalData.appInfo}"),
                    if (widget.globalData.appInfo.isNotEmpty)
                      {showDownloadDialog(context, widget.globalData.appInfo)}
                  }
                else
                  {globals.showMessage('NO INTERNET'.tr())}
              },
            ),
            BounceButton(
              text: 'My Team'.tr(),
              color: Colors.blue,
              asset: myTeam.isNotEmpty
                  ? Image.asset('assets/$myTeam.png', width: 20)
                  : Image.asset('assets/questionmark.png', width: 20),
              onPressed: () async => {
                if (widget.globalData.isConnected)
                  await showMyTeamDialog(context)
                else
                  globals.showMessage('NO INTERNET'.tr())
              },
            ),
          ],
        ),
        globals.devider20,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //DISCLAIMER
            BounceButton(
                text: 'Disclaimer'.tr(),
                color: const Color.fromARGB(99, 33, 149, 243),
                icon: const Icon(Icons.dangerous_outlined,
                    color: Color.fromARGB(150, 33, 149, 243)),
                onPressed: () async => {await showDialogDisclaimer(context)}),
            //INFO
            BounceButton(
              text: 'App Info'.tr(),
              color: const Color.fromARGB(99, 33, 149, 243),
              icon: const Icon(Icons.info_outline_rounded,
                  color: Color.fromARGB(150, 33, 149, 243)),
              onPressed: () async => {await showDialogInfo(context)},
            )
          ],
        )
      ],
    ))));
  }
}
