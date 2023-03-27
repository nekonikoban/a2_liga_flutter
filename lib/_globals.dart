import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart' as parser;

class LoginState with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

class Globals extends ChangeNotifier {
  Globals() {
    //print("GLOBALS INIT");
  }

  //APP VERSION
  getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  final dateToday = DateUtils.dateOnly(DateTime.now());
  final appReleasesURL = 'https://a2-liga.vercel.app/';
  final httpClient = Dio();
  final httpHeader = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE",
    "Access-Control-Allow-Headers": "Accept, Content-Type, Authorization",
  };
  final httpPosavinaHeader = {
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'accept-encoding': 'gzip, deflate, br',
    'accept-language': 'en-US,en;q=0.9',
    'cache-control': 'max-age=0',
    'sec-ch-ua':
        '"Chromium";v="110", "Not A(Brand";v="24", "Google Chrome";v="110"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': 'Windows',
    'sec-fetch-user': '?1',
    'upgrade-insecure-requests': '1',
    'connection': 'keep-alive',
  };

  final int refreshRate = 1;

  static const mainTableURL =
      'https://www.posavinasport.com/Ko%C5%A1arka/lmo.php?file=/3_12%20momcadi.l98';
  static const mainYoutubeChannelURL =
      'https://www.youtube.com/@a2liga-jugksbih352/videos';
  static const youtubeAPI = 'AIzaSyD6Pw_8-lLsZRFJs5SC0qwEDs01PSXLPgM';
  //MAIN TABLE
  final numOfTeams = 10;
  final imageWidth = 80.0;
  final imageHeight = 80.0;
  final tableTextSize = 17.0;
  final tableTextColor = Colors.white;
  final tableFillValue = TableCellVerticalAlignment.fill;
  //TEAM TABLE
  final maxRounds = 18;
  //SCHEDULE TABLE
  final maxSchedules = 4;
  //PLACEHOLDER FOR EMPTY STRING
  final emptyPlaceholder = '_ ? _';

  List<String> initTeamNames(arr) {
    arr.add('UKK IUS Wolves (Ilidža)');
    arr.add('KK Goražde');
    arr.add('KK J&A Akademija (Mostar)');
    arr.add('KK Ilidža');
    arr.add('KK Mladost (Ilijaš)');
    arr.add('KK Lider 5 (Mostar)');
    arr.add('KK Bosna Meridian - bet (Sarajevo)');
    arr.add('KK Lokomotiva (Mostar)');
    arr.add('KK Koš (Sarajevo)');
    arr.add('KK Real Way (Sarajevo)');
    return arr;
  }

  List<String> initTeamImages(arrImg) {
    arrImg.add('UKK IUS Wolves (Ilidža)');
    arrImg.add('KK Goražde');
    arrImg.add('KK J&A Akademija (Mostar)');
    arrImg.add('KK Ilidža');
    arrImg.add('KK Mladost (Ilijaš)');
    arrImg.add('KK Lider 5 (Mostar)');
    arrImg.add('KK Bosna Meridian - bet (Sarajevo)');
    arrImg.add('KK Lokomotiva (Mostar)');
    arrImg.add('KK Koš (Sarajevo)');
    arrImg.add('KK Real Way (Sarajevo)');
    return arrImg;
  }

  bool isLogged = false;

  final appBarColor = const Color.fromARGB(255, 26, 3, 61);
  final mainColor = const Color.fromARGB(255, 6, 54, 108);
  final navMainColor = const Color.fromARGB(255, 6, 54, 108);
  final glowColor = const Color(0xFF40D0FD);
  final glowColorDarken = const Color.fromARGB(255, 64, 111, 253);
  final cancelColor = const Color.fromARGB(255, 203, 63, 91);
  final finishedColor = const Color.fromARGB(255, 205, 24, 24);

  final textStyleMain = const TextStyle(
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
  final textStyleSchedule =
      const TextStyle(color: Colors.white, fontSize: 17.0);
  final textStyleSharing = const TextStyle(color: Colors.black, fontSize: 17);

  final fontFam = "Anurati";

  final keyId = "__id__";
  final keyUsername = "__username__";
  final keyEmail = "__email__";
  final keyVerified = "__verified__";
  final keyOnline = "__online__";
  final keyRole = "__role__";
  final keyAvatar = "__avatar__";

  PreferredSizeWidget appBar(title) {
    return AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        )),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "$title".tr(),
          style: const TextStyle(
              fontFamily: "Anurati", fontSize: 20, fontWeight: FontWeight.bold),
        ));
  }

  Widget wLoader = LoadingAnimationWidget.staggeredDotsWave(
    color: Colors.white,
    size: 50,
  );

  void loadingDialog(title, context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return true;
          },
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(title, style: textStyleSchedule),
                      const SizedBox(height: 50),
                      wLoader
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget devider20 = const Divider(
    height: 20,
    thickness: 0,
    indent: 20,
    endIndent: 0,
    color: Colors.transparent,
  );

  ButtonStyle elevatedBtnStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF40D0FD).withOpacity(0.25),
      minimumSize: const Size(150, 40),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          side: BorderSide(color: Color.fromARGB(0, 255, 57, 43))));

  void showMessage(message) => {
        showToast(message.toString().toUpperCase(),
            duration: const Duration(milliseconds: 5000),
            position: ToastPosition.top,
            backgroundColor: const Color.fromARGB(24, 0, 0, 0),
            radius: 20.0,
            textStyle: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: fontFam),
            dismissOtherToast: true)
      };

  void showTeamName(message) => {
        showToast(message.toString(),
            duration: const Duration(milliseconds: 5000),
            position: ToastPosition.center,
            backgroundColor: const Color.fromARGB(88, 0, 0, 0),
            radius: 20.0,
            textStyle: const TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: 18.0),
            dismissOtherToast: true)
      };

  Future<List<String>> getUserDataFromCache(
      String keyId,
      String keyUsername,
      String keyEmail,
      String keyVerified,
      String keyOnline,
      String keyRole,
      String keyAvatar) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(keyId) == null
        ? []
        : [
            prefs.get(keyId) == null ? "" : prefs.get(keyId).toString(),
            prefs.get(keyUsername) == null
                ? ""
                : prefs.get(keyUsername).toString(),
            prefs.get(keyEmail) == null ? "" : prefs.get(keyEmail).toString(),
            prefs.get(keyVerified) == null
                ? ""
                : prefs.get(keyVerified).toString(),
            prefs.get(keyOnline) == null ? "" : prefs.get(keyOnline).toString(),
            prefs.get(keyRole) == null ? "" : prefs.get(keyRole).toString(),
            prefs.get(keyAvatar) == null ? "" : prefs.get(keyAvatar).toString()
          ];
  }

  Future<String> getFromCacheByKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) == null ? '' : prefs.get(key).toString();
  }

  //RETURNS `TRUE` IF SUCCESSFUL OTHERWISE `FALSE`
  Future setToCacheByKey(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (value.runtimeType.toString()) {
      case 'int':
        prefs.setInt(key, value as int);
        return true;
      case 'double':
        prefs.setDouble(key, value as double);
        return true;
      case 'String':
        prefs.setString(key, value as String);
        return true;
      case 'bool':
        prefs.setBool(key, value as bool);
        return true;
      default:
        return false;
    }
  }

  printingAllPreferencesKeys() async {
    final preferences = await SharedPreferences.getInstance();
    // ignore: avoid_print
    /* print("|||||||||||||CACHED||||||||||||||||"); */

    int prefsLenght = preferences.getKeys().length;
    //Set prefsSet = Set.from(preferences.getKeys());

    for (var i = 0; i < prefsLenght; i++) {
      /* print(prefsSet.elementAt(i).toString() +
          " => " +
          preferences.get(prefsSet.elementAt(i).toString()).toString() +
          " [" +
          preferences
              .get(prefsSet.elementAt(i).toString())
              .runtimeType
              .toString() +
          "]"); */
    }
    // ignore: avoid_print
    /* print("||||||||||||||CACHED||||||||||||||||"); */
  }

  Future clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  final awesomeNotifications = AwesomeNotifications();

  //GENERAL NOTIFICATION PUSH
  notificationPush(String title, String message, String bigPicture,
      String largeIcon, NotificationLayout layout) async {
    await awesomeNotifications.createNotification(
        content: NotificationContent(
      id: 1,
      channelKey: 'alerts',
      title: title,
      body: message,
      summary: 'Following'.tr(),
      payload: {"key": "val"},
      bigPicture: 'asset://assets/awesome_notifications/images/$bigPicture.png',
      largeIcon: 'asset://assets/awesome_notifications/images/$largeIcon.png',
      notificationLayout: layout,
    )

        /* actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ] */
        );
  }

  //DOWNLOAD PUSH
  notificationUpdatePush(int id, String title, String message,
      String bigPicture, String largeIcon, NotificationLayout layout) async {
    await awesomeNotifications.createNotification(
        content: NotificationContent(
      id: id,
      channelKey: 'alerts',
      title: title,
      body: message,
      summary: 'Following'.tr(),
      payload: {"key": "val"},
      bigPicture: 'asset://assets/awesome_notifications/images/$bigPicture.png',
      largeIcon: 'asset://assets/awesome_notifications/images/$largeIcon.png',
      notificationLayout: layout,
    ));
  }

  final infoUsage =
      "Here you can choose you favorite club and turn on/off notifications accordingly. You will recieve notifications when either your club or the table is updated.";
  final infoText =
      "This script is based on the Windows Software LigaManager '98 Free by Frank Hollwitz. League Manager Online is a much better version of that program. Since it is based on PHP, LMO can be used on different platforms, and this takes place comfortably through a normal server. Through various extensions (Addons), LMO has become diverse over time. With these scripts, normal leagues can be distinguished by sports types, as well as cup competitions can be administered. A large number of different Addons make LMO a complete solution for anyone who wants to administer sports leagues and present them to the public. This script is under the GPL, which means it can be modified and used freely. But copyright notices may not be deleted or altered.";
  final disclaimerText =
      "This app is made with sole purpose for easier access of the information on A2 Basketball League that resides on www.posavinasport.com Data is scraped from the mentioned site and it does not have any direct impact on the actual data which is presented in the actual app nor does it impacts server directly or indeirectly.";

  //RETURNS TRUE IF WIFI, MOBILE OR VPN, OTHERWISE FALSE
  getNetworkStatus() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // MOBILE
      return true;
      //return "MOBILE";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // WIFI
      return true;
      //return "WIFI";
    } else if (connectivityResult == ConnectivityResult.vpn) {
      // VPN
      return true;
      //return "VPN";
    } else if (connectivityResult == ConnectivityResult.none) {
      //NOT CONNECTED
      return false;
      //return "DISCONNECTED";
    }
  }

  //SCRAPE WEB ON APP CHANGES
  Future scrapeAvailableAppData(currentVersion) async {
    final response = await httpClient.get('https://a2-liga.vercel.app/');
    final document = parser.parse(response.data);
    final buttonData = document.querySelector('button');

    if (buttonData == null) {
      return '';
    } else {
      String latestAppID = buttonData.attributes['id'].toString();
      if (latestAppID.isEmpty) {
        return '';
      } else {
        latestAppID = latestAppID.replaceAll(RegExp(r'_'), '.');
        if (latestAppID == currentVersion) {
          return '';
        } else {
          final anchorData = document.querySelector('a');
          String downloadLink = anchorData!.attributes['href'].toString();
          if (downloadLink.isEmpty || downloadLink == 'null') {
            return '';
          }
          return downloadLink;
        }
      }
    }
  }

  //SCRAPE MAIN TABLE
  Future scrapeData(context, array, isInitial, isScrapeDone) async {
    array.clear();
    //GET DATA FROM SCRAPE AND PARSE IT
    final response = await httpClient.get(mainTableURL);
    final document = parser.parse(response.data);
    //SELECTING TABLE WITH CLASS `lmoInner` (SECOND TABLE) (FIRST ONE IS 'SCHEDULE' FROM ABOVE)
    final tableMain = document.getElementsByClassName('lmoInner')[1];
    final rows = tableMain.getElementsByTagName('tr');

    //GET CURRENT ROUND
    final tableSchedule = document.getElementsByClassName('lmoInner')[0];
    final th = tableSchedule.getElementsByTagName('th').first;
    int kolo = int.parse(th.innerHtml.split('.')[0].isNotEmpty
        ? th.innerHtml.split('.')[0]
        : '0');

    //'tmp' IS TEMPORARY STRING WHICH CONCENTRATES MULTIPLE ROWS INTO ONE SPERATED BY COMMAS
    //'tmp' AFTER CONCENTRATION IS ADDED TO THE ACTUALL ARRAY AFTER SECOND LOOP SO IT CAN BE 'SPLITTABLE'
    //SETTING `index` SO WE CATCH EXACT NUMBER OF TEAMS AND NOTHING ELSE
    String tmp = '';
    int index = 0;
    for (final row in rows) {
      if (index >= numOfTeams + 1) break;
      final cells = row.getElementsByTagName('td');
      for (final cell in cells) {
        if (cell.text.trim().isNotEmpty && cell.text.trim() != ':') {
          tmp += '${cell.text.trim()},';
        }
      }
      if (tmp.isNotEmpty) {
        array.add(tmp);
      }
      tmp = '';
      index++;
    }
    //REMOVE `KAZNE` FROM ARRAY
    for (var i = 0; i < numOfTeams; i++) {
      //REMOVE STRING `KAZNE` IF IT EXISTS. HAD TO SPLIT ARRAY AND MANUALLY REJOIN IT
      if (array[i].split(',')[2].contains("Kazne")) {
        List<String> splitArray = array[i].split(',');
        if (splitArray.length > 2 && splitArray[2].contains("Kazne")) {
          splitArray.removeAt(2);
          array[i] = splitArray.join(',');
        }
      }
    }
    if (isInitial) {}
    //SET `KOLO` TO CACHE MEM
    await setToCacheByKey('__kolo__', kolo);
    //SET `myTeam` TO CACHE
    String myTeam = await getFromCacheByKey('__myteam__');

    return [array, myTeam];
  }

  bool isDataUpdated(current, initial, myTeam) {
    /* print("MYTEAM => $myTeam , ISEMPTY => ${myTeam.isEmpty}"); */
    if (current.isEmpty || initial.isEmpty) return false;
    bool equal = true;

    //1. CHECK IF MY TEAM IS UPDATED AND NOTIFY
    for (int i = 0; i < current.length; i++) {
      if (initial[i] != current[i] &&
          myTeam.isNotEmpty &&
          myTeam == current[i].split(',')[1]) {
        /* print("MYTEAM HAS BEEN UPDATED [$myTeam]"); */
        equal = false;
        notificationPush(
            myTeam,
            '${'${'The team you are following'.tr()} $myTeam '} ${'has been updated'.tr()}',
            'a2liga',
            'a2liga',
            NotificationLayout.Messaging);
        //SAVE MYTEAMDATA TO CACHE
        setToCacheByKey('__my_team_data__', current[i]);
        break;
      }
    }
    //2. CHECK IF ANY OTHER ROW HAS BEEN UPDATED AND NOTIFY
    for (int i = 0; i < current.length; i++) {
      if (initial[i] != current[i]) {
        //NOTIFIES ANY CHANGES IN A STREAM
        /* print("TABLE HAS BEEN UPDATED, BUT NOT MY TEAM"); */
        equal = false;
        notificationPush(
            'Table Updated'.tr(),
            'The table has been updated'.tr(),
            'a2liga',
            'a2liga',
            NotificationLayout.Messaging);
        break;
      }
    }
    //RETURN TRUE IF CHANGED
    if (!equal) {
      /* print("NOT EQUAL, UPDATING STREAM..."); */
      return true;
    } else {
      /* print("EQUAL, NO CHANGES IN A STREAM"); */
      return false;
    }
  }

  //CHECK IF MY TEAM HAS CHANGED SINCE LAST APP USAGE
  Future<bool> hasMyTeamChangedSinceLastStartup(array, myTeamData) async {
    if (array.isEmpty) return false;
    for (int i = 0; i < numOfTeams; i++) {
      if (array[i].split(',')[1] == myTeamData.split(',')[1]) {
        if (myTeamData != array[i]) {
          //UPDATE CACHE
          await setToCacheByKey('__my_team_data__', array[i]);
          return true;
        }
      }
    }
    return false;
  }

  String currentTimeStamp() {
    DateTime now = DateTime.now();

    int hour = now.hour;
    int minute = now.minute;

    String dayOfWeek = DateFormat('EEEE').format(now);

    return '$dayOfWeek $hour:$minute';
  }

  //DATE PICKER WIDGET
  Future<void> selectDate(BuildContext context, selectedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: mainColor,
              onPrimary: glowColor,
              onSurface: mainColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: mainColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      showToast('IN DEVELOPMENT');
      /* setState(() => {_selectedDate = picked, isScrapeDone = false});
      await scrapeScheduleForDay(_selectedDate.day);
      setState(() => {isDateChanged = true, isScrapeDone = true}); */
    }
  }

  Future scrapeTeamSchedule(
      arrayTeamSchedule, arrayTeamScheduleImages, teamId) async {
    //CLEAR PREVIOUS RESULTS
    arrayTeamSchedule.clear();
    arrayTeamScheduleImages.clear();

    String url =
        'https://www.posavinasport.com/Ko%C5%A1arka/lmo.php?action=program&file=/3_12%20momcadi.l98&selteam=$teamId';
    final response = await httpClient.get(url);
    final document = parser.parse(response.data);

    final table = document.getElementsByClassName('lmoInner').first;
    final rows = table.getElementsByTagName('tr');

    // Loop through the rows and print out the text in each cell
    String tmp = '';
    for (final row in rows) {
      final cells = row.getElementsByTagName('td');

      for (final cell in cells) {
        tmp += '${cell.text.trim()},';
      }
      if (tmp.isNotEmpty) arrayTeamSchedule.add(tmp);

      tmp = '';

      if (arrayTeamSchedule.length >= maxRounds) {
        break;
      }
    }

    //ADD CLUB IMAGES (NEED TO DO NESTED LOOP SINCE IN ONE ROW THERE ARE 2 TEAMS)
    for (var i = 0; i < arrayTeamSchedule.length; i++) {
      if (arrayTeamSchedule[i].contains(",")) {
        var tmp = arrayTeamSchedule[i].split(',');
        for (var j = 3; j < 6; j++) {
          if (j == 4) continue;
          arrayTeamScheduleImages.add(tmp[j]);
        }
      }
    }
  }

  Future scrapeTeamGraphURL(teamGraph, teamId) async {
    String url =
        'https://www.posavinasport.com/Ko%C5%A1arka/lmo.php?action=graph&file=/3_12%20momcadi.l98&stat1=$teamId';
    final response = await httpClient.get(url);

    final document = parser.parse(response.data);
    var imageElement = document.querySelector('img[alt="Uporediti"]');

    if (imageElement != null) {
      /* print('Found link => ${imageElement.outerHtml.split("\"")[1]}'); */
      teamGraph = imageElement.outerHtml.split("\"")[1];
      /* print('TEAM GRAPH => $teamGraph'); */
    } else {
      /* print('No image tag found with the specified alt attribute'); */
    }
    //setState(() => isGraphScraped = true);
  }

  Future scrollToTeam(widgetKey) async {
    final context = widgetKey.currentContext!;
    await Scrollable.ensureVisible(context);
  }

  Future scrapeScheduleForDay(arrayDate, arrayDateImages, day) async {
    final url =
        'https://www.posavinasport.com/Ko%C5%A1arka/lmo.php?action=results&tabtype=0&file=/3_12%20momcadi.l98&st=${(day).toString()}';
    final response = await httpClient.get(url);

    final document = parser.parse(response.data);
    final table = document.getElementsByClassName('lmoInner').first;
    final rows = table.getElementsByTagName('tr');

    String tmp = '';
    for (final row in rows) {
      final cells = row.getElementsByTagName('td');

      for (final cell in cells) {
        if (cell.text.trim().isNotEmpty &&
            cell.text.trim() != ':' &&
            cell.text.trim() != '-') {
          tmp += '${cell.text.trim()},';
        }
      }
      if (arrayDate.isNotEmpty) {
        arrayDate.add(tmp);
      }
      tmp = '';
      if (arrayDate.length >= 6) {
        break;
      }
    }
    //ADD CLUB IMAGES (NESTED LOOP SINCE THERE ARE 2 TEAMS IN ONE ROW)
    for (var i = 0; i < maxSchedules; i++) {
      if (arrayDate[i].contains(",")) {
        var tmp = arrayDate[i].split(',');
        for (var j = 1; j < 3; j++) {
          arrayDateImages.add(tmp[j]);
        }
      }
    }
  }

  //SCROLL CONTROLLER
  void scrollToIndex(rowKey, scrollController, int index) {
    final RenderBox? rowBox =
        rowKey.currentContext?.findRenderObject() as RenderBox?;
    final double? rowWidth = rowBox?.size.width;
    final double? itemWidth = rowWidth != null ? rowWidth / 5 : null;

    if (itemWidth != null) {
      scrollController.animateTo(
        itemWidth * index,
        duration: const Duration(seconds: 3),
        curve: Curves.easeInOut,
      );
    }
  }
}
