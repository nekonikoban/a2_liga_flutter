import 'dart:async';
import 'package:a2_league/schedule.dart';
import 'package:a2_league/settings.dart';
import 'package:a2_league/team.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '_global_data.dart';
import '_global_data_stream.dart';
import '_globals.dart';
import '_splash.dart';
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //LOCALIZATION
  await EasyLocalization.ensureInitialized();
  //AWESOME NOTIFICATIONS
  await AwesomeNotifications().initialize(
    null,
    [
      //ID = 2 => FOR UPDATES
      NotificationChannel(
          channelKey: 'alerts',
          channelName: 'Basic Notifications',
          channelDescription: 'Basic Tests',
          defaultColor: const Color.fromARGB(255, 14, 44, 151),
          ledColor: const Color.fromARGB(255, 14, 44, 151)),
    ],
  );
  final initialArrayStream = GlobalDataStream();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalData()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('bs', 'BA')],
        path: 'assets/translations',
        startLocale: const Locale('en', 'US'),
        child: MyApp(initialArrayStream: initialArrayStream),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalDataStream initialArrayStream;
  MyApp({Key? key, required this.initialArrayStream}) : super(key: key);
  //ROOT WIDGET OF APP
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'A2Minimized',
        theme: ThemeData(
          canvasColor: Provider.of<GlobalData>(context).mainThemeColor,
        ),
        home: const SplashScreen());
  }
}

class MyHomePage extends StatefulWidget {
  final GlobalDataStream globalDataStream;
  const MyHomePage(
      {Key? key, required this.globalDataStream, required this.title})
      : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalData globalData = GlobalData();
  late StreamSubscription<List<String>> _streamSubscription;
  final globals = Globals();

  String following = 'Following';

  bool isInitial = true;
  bool isScrapeDone = false;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  late Timer _timer;
  double refreshRate = 1.0;
  List<String> array = [];
  String myTeam = '';

  //THIS FUNCTION IS RAN ONCE UPON STARTUP
  Future runScrape() async {
    //SCRAPE MAIN TABLE
    globals.scrapeData(context, array, true, isScrapeDone).then((resultArray) {
      following = 'Following';
      //HANDLE DIO ERROR [0 => ARRAY   1 => MYTEAM]
      if (resultArray[0].isEmpty) {
        //THIS WILL LEAVE LOADING SCREEN LOOP
        following = '';
        globalData.appBarTitle = 'WEBSITE NOT FOUND!'.tr();
        return;
      }
      //UPDATE STREAM TO CURRENT ARRAY FROM TABLE
      setState(() => {
            isInitial = false,
            isScrapeDone = true,
            widget.globalDataStream.updateData(resultArray[0]),
          });
      //SET STREAM LISTENER FOR CHANGES
      _streamSubscription = widget.globalDataStream.stream.listen((newArray) {
        setState(() => {
              array.clear(),
              array.addAll(newArray),
            });
      });
    }).then((hasMyDataChanged) => {
          //CHECK IF MY TEAM HAS CHANGED SINCE LAST STARTUP
          globals.getFromCacheByKey('__my_team_data__').then((myTeamData) => {
                if (myTeamData.isEmpty || array.isEmpty)
                  {
                    // print(
                    // "YOU DONT HAVE ANY CACHED TEAM DATA OR ARRAY IS EMPTY")
                  }
                else
                  {
                    globals
                        .hasMyTeamChangedSinceLastStartup(array, myTeamData)
                        .then((hasChanged) => {
                              if (hasChanged)
                                {
                                  globals.notificationPush(
                                      'Update'.tr(),
                                      '${myTeamData.split(',')[1]} ${'has been updated'.tr()} ${'since last time you were here'.tr()}',
                                      'a2liga',
                                      'a2liga',
                                      NotificationLayout.Messaging)
                                }
                              else
                                {
                                  {
                                    /* print(
                                        "TEAM DATA DID NOT CHANGE SINCE LAST APP START") */
                                  }
                                }
                            })
                  }
              })
        });
  }

  //THIS FUNCTION RUNS PERIODICALLY, IT WILL SCRAPE DATA AND IF ARRAY IS DIFFERENT THEN STREAM IT WILL UPDATE
  void timerStart() {
    Completer completer; // COMPLETER TO PAUSE SCRAPING
    _timer = Timer.periodic(Duration(hours: globals.refreshRate), (timer) {
      if (globalData.isConnected) {
        completer = Completer(); // CREATE A NEW COMPLETER FOR EACH SCRAPE
        globals
            .scrapeData(context, array, isInitial, isScrapeDone)
            .then((currentArray) {
          if (globals.isDataUpdated(currentArray[0],
              widget.globalDataStream.initialArray, currentArray[1])) {
            widget.globalDataStream.updateData(currentArray[0]);
            globals.notificationPush(
                'Update'.tr(),
                '${'Table has been updated on'.tr()} ${globals.currentTimeStamp()}',
                'a2liga',
                'a2liga',
                NotificationLayout.Messaging);
            completer.complete(); // RESOLVE COMPLETER TO RESUME SCRAPING
          } else {
            setState(() {});
            completer.complete(); // RESOLVE COMPLETER TO RESUME SCRAPING
          }
        });
        completer.future.then((_) {
          if (mounted) {
            // IF WIDGET IS STILL MOUNTED
            setState(() {});
          }
          //RESTART TIMER
          timerCancel().then((isCanceled) {
            if (isCanceled && mounted) {
              // IF WIDGET IS STILL MOUNTED
              timerStart();
            }
          });
        });
      } else {
        /* print("NO INTERNET..."); */
      }
    });
  }

  Future timerCancel() async {
    if (_timer.isActive) {
      _timer.cancel();
      return true;
    }
    return true;
  }

  void getAppInfo() async {
    globals.getAppInfo().then((appInfo) => {
          if (globalData.isConnected && appInfo.version.isNotEmpty)
            {
              globals
                  .scrapeAvailableAppData(appInfo.version)
                  .then((webInfo) => {
                        if (webInfo.isNotEmpty)
                          {
                            //PUSH NOTIFICATIONS
                            globals.notificationUpdatePush(
                                2,
                                'Update Available'.tr(),
                                '${'There is newer version of app available.'.tr()}\n${'Go to settings and press download button to update.'.tr()}',
                                'a2liga',
                                'a2liga',
                                NotificationLayout.BigText),
                            //SAVE APP INFO
                            Provider.of<GlobalData>(context, listen: false)
                                .updateAppInfo(appInfo.version),
                            Provider.of<GlobalData>(context, listen: false)
                                .updateDownloadLink(webInfo),
                          }
                      })
            }
        });
  }

  @override
  void initState() {
    super.initState();
    //INIT NOTIFICATION LISTENERS (FOR WEBSITE PUSH)
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
    //INIT REFRESH RATE
    globals.getFromCacheByKey('__refresh_rate__').then((refreshR) => {
          if (refreshR.isEmpty)
            refreshRate = 1.0
          else
            {
              refreshRate = double.parse(refreshR.toString()),
              Provider.of<GlobalData>(context, listen: false)
                  .updateRefreshRate(refreshRate)
            }
        });
    //CHECK IF DEVICE IS ALLOWED TO PUSH NOTIFICATIONS
    AwesomeNotifications().isNotificationAllowed().then((isAllowd) => {
          if (!isAllowd)
            {AwesomeNotifications().requestPermissionToSendNotifications()}
        });
    //CHECK NETWORK CONNECTION
    globals.getNetworkStatus().then((isConnected) => {
          //LISTEN TO CONNECTION CHANGE
          Connectivity()
              .onConnectivityChanged
              .listen((ConnectivityResult result) {
            globalData
                .updateConnectionStatus(result != ConnectivityResult.none);
            if (globalData.isConnected && !isInitial) {
              globalData.updateConnectionStatus(true);
              timerStart();
            } else if (globalData.isConnected && isInitial) {
              globalData.updateConnectionStatus(true);
              //GET APP INFO, NOTIFY USER IF NEWER VERSION IS AVAILABLE
              getAppInfo();
              //THIS WILL BE RUN ONCE UPON APP START
              runScrape().then((value) => {timerStart()});
            } else if (!globalData.isConnected) {
              globalData.updateConnectionStatus(false);
              globals.showMessage('NO INTERNET'.tr());
              //DONT CANCEL TIMER BEFORE ITS INITIALIZED
              if (!isInitial) {
                timerCancel();
              }
            }
          }),
        });
    //NAVIGATION LISTENER
    _controller.addListener(() {
      setState(() {
        //print("controller => ${_controller.index}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    globals.printingAllPreferencesKeys();
    /* globals.clearCache(); */
    return OKToast(
        child: Scaffold(
      appBar: globals.appBar(Provider.of<GlobalData>(context).appBarTitle !=
              'STATS'
          ? '${following.tr()} ${Provider.of<GlobalData>(context).appBarTitle}'
          : 'STATS'),
      body: Container(child: navigation(context)),
    ));
  }

  //NAVIGATION
  Widget navigation(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: buildScreens(context),
      items: navigationItems(),
      confineInSafeArea: true,
      neumorphicProperties: const NeumorphicProperties(
        shape: BoxShape.circle,
        curveType: CurveType.emboss,
        bevel: 20.0,
      ),
      backgroundColor:
          const Color.fromARGB(0, 0, 0, 0), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: const Color.fromARGB(0, 0, 0, 0),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 250),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }

  List<PersistentBottomNavBarItem> navigationItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.table),
        title: ("TABLE".tr()),
        textStyle: TextStyle(fontFamily: globals.fontFam),
        activeColorPrimary:
            Provider.of<GlobalData>(context, listen: false).mainThemeColor ==
                    globals.darkThemeColor
                ? globals.darkNavColor
                : globals.glowColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        contentPadding: 1.0,
      ),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.schedule_rounded),
          title: ("SCHEDULE".tr()),
          textStyle: TextStyle(fontFamily: globals.fontFam),
          activeColorPrimary:
              Provider.of<GlobalData>(context, listen: false).mainThemeColor ==
                      globals.darkThemeColor
                  ? globals.darkNavColor
                  : globals.glowColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          contentPadding: 1.0),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_2_rounded),
          title: ("TEAMS".tr()),
          textStyle: TextStyle(fontFamily: globals.fontFam),
          activeColorPrimary:
              Provider.of<GlobalData>(context, listen: false).mainThemeColor ==
                      globals.darkThemeColor
                  ? globals.darkNavColor
                  : globals.glowColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          contentPadding: 1.0),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: ("SETTINGS".tr()),
          textStyle: TextStyle(fontFamily: globals.fontFam),
          activeColorPrimary:
              Provider.of<GlobalData>(context, listen: false).mainThemeColor ==
                      globals.darkThemeColor
                  ? globals.darkNavColor
                  : globals.glowColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          contentPadding: 1.0),
      /* PersistentBottomNavBarItem(
          icon: const Icon(Icons.exposure_minus_1_sharp),
          title: ("TEST".tr()),
          textStyle: TextStyle(fontFamily: globals.fontFam),
          activeColorPrimary: globals.glowColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          contentPadding: 1.0), */
    ];
  }

  List<Widget> buildScreens(context) {
    return [
      isScrapeDone
          ? SizedBox(
              width: MediaQuery.of(context).size.width - 10,
              child: MainTableWidget(array: array))
          : Center(child: globals.wLoader),
      ScheduleScreen(globalData: globalData),
      TeamsScreen(globalData: globalData),
      SettingsScreen(globalData: globalData, array: array),
    ];
  }

  //EXTRACTING `TAPPED NOTIFICATION` onActionReceivedMethod FROM AwesomeNotifications NotificationController
  //USER TAPPED NOTIFICATION
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    //ID = 2 => FOR UPDATES
    if (receivedAction.id == 2) {
      await launchUrl(Uri.parse(GlobalData().getDownloadLink()));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamSubscription.cancel();
    super.dispose();
  }
}
