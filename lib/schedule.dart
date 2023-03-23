import 'dart:async';
import 'package:a2_league/_global_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:html/parser.dart' as parser;
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import '_globals.dart';
import 'custom-widgets/table_row_schedule.dart';

class ScheduleScreen extends StatefulWidget {
  final GlobalData globalData;
  const ScheduleScreen({Key? key, required this.globalData}) : super(key: key);
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Globals globals = Globals();

  final GlobalKey _rowKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  final DateTime _selectedDate = DateTime.now();
  List<String> arrayOld = [];
  List<String> array = [];
  List<String> arrayImages = [];
  List<String> arrayDate = [];
  List<String> arrayDateImages = [];
  List<String> arrayX = [];
  List<String> arrayXImages = [];
  bool isScrapeDone = false;
  bool isDateChanged = false;
  int round = 0;

  //INIT
  @override
  void initState() {
    super.initState();
    //GET `KOLO` AND IF CONNECTED SCRAPE DATA
    globals.getFromCacheByKey('__kolo__').then((kolo) => {
          if (kolo.isNotEmpty && kolo != 'null')
            {
              setState(() => {round = int.parse(kolo)}),
              if (widget.globalData.isConnected)
                {
                  scrapeSchedule(array, arrayImages, kolo).then((val) => {
                        setState(() => {
                              isScrapeDone = true,
                              widget.globalData.updateConnectionStatus(true)
                            })
                      })
                }
              else
                {globals.showMessage('NO INTERNET'.tr())}
            }
        });
    //LISTEN TO CONNECTION CHANGE
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      widget.globalData
          .updateConnectionStatus(result != ConnectivityResult.none);
      if (widget.globalData.isConnected) {
        scrapeSchedule(array, arrayImages, round).then((val) => {
              setState(() => {
                    round = round,
                    isScrapeDone = true,
                    widget.globalData.updateConnectionStatus(true)
                  })
            });
      } else {
        globals.showMessage('NO INTERNET'.tr());
      }
    });
  }

  Future scrapeSchedule(array, arrayImages, kolo) async {
    //CLEAN ARRAYS
    array.clear();
    arrayImages.clear();

    setState(() => {isScrapeDone = false});
    final url =
        'https://www.posavinasport.com/Ko%C5%A1arka/lmo.php?action=results&tabtype=0&file=/3_12%20momcadi.l98&st=${(kolo).toString()}';
    final response = await globals.httpClient.get(url);

    final document = parser.parse(response.data);
    //SELECTING TABLE WITH CLASS `lmoInner` (FIRST TABLE)
    final table = document.getElementsByClassName('lmoInner').first;
    final rows = table.getElementsByTagName('tr');

    String tmp = '';
    for (final row in rows) {
      final cells = row.getElementsByTagName('td');

      for (final cell in cells) {
        tmp += '${cell.text.trim()},';
      }

      if (tmp.isNotEmpty) array.add(tmp);

      tmp = '';

      if (array.length >= 5) break;
    }
    //ADD CLUB IMAGES (NESTED LOOP SINCE IN EVERY ROW THERE ARE 2 TEAMS)
    //SO FOR EVERY ROW WE HAVE TO LOOP TWICE
    for (var i = 0; i < globals.maxSchedules; i++) {
      if (array[i].contains(",")) {
        var tmp = array[i].split(',');
        for (var j = 2; j < 5; j++) {
          if (j == 3) continue;
          arrayImages.add(tmp[j]);
        }
      }
    }
    setState(() => {kolo = kolo, isScrapeDone = true});
  }

  void scrollToKolo(index) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => globals.scrollToIndex(_rowKey, _scrollController, index % 5));
  }

  //KOLO FILTER
  _showKoloDialog(context) async {
    scrollToKolo(round);
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
                    Text('PICK A ROUND'.tr(),
                        style: TextStyle(
                            fontFamily: globals.fontFam, color: Colors.white)),
                  ],
                ),
                globals.devider20,
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: Row(
                      key: _rowKey,
                      children: [
                        for (int i = 1; i <= 22; i++)
                          Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: i == round
                                  ? globals.glowColor
                                  : globals.mainColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: GestureDetector(
                                    child: Text(
                                      i.toString(),
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () async => {
                                          Navigator.of(context).pop(),
                                          if (widget.globalData.isConnected)
                                            {
                                              await scrapeSchedule(
                                                  array, arrayImages, i)
                                            }
                                          else
                                            {
                                              globals.showMessage(
                                                  'NO INTERNET'.tr())
                                            }
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

  Widget table(BuildContext context) {
    return !isScrapeDone
        ? Center(child: globals.wLoader)
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //ROW
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SELECT ROUND
                    FloatingActionButton(
                      onPressed: () async => {await _showKoloDialog(context)},
                      tooltip: 'Search by Round',
                      backgroundColor: globals.mainColor,
                      child: const Icon(Icons.schedule_rounded),
                    ),
                    //SELECT DATE
                    FloatingActionButton(
                      onPressed: () => {
                        globals.selectDate(context, _selectedDate),
                      },
                      tooltip: 'Search by Date',
                      backgroundColor: globals.mainColor,
                      child: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                //DEVIDER
                globals.devider20,
                //CURRENT ROUND
                Center(
                  child: Text('${'CURRENT ROUND'.tr()}$round',
                      style: TextStyle(
                          color: Colors.white, fontFamily: globals.fontFam)),
                ),
                //DEVIDER
                globals.devider20,
                //SHOW TABLE
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //IF DATE IS SELECTED SHOW TABLE BY SELECTED DATE
                    isDateChanged
                        ? Center(
                            //SHOW TABLE BY DATE
                            child: CustomScheduleTableRow(
                                    arrayTeams: arrayX,
                                    arrayImages: arrayXImages,
                                    isDataScraped: isScrapeDone)
                                .tableRow())
                        //SHOW CURRENT TABLE BY ROUND
                        : Center(
                            child: CustomScheduleTableRow(
                                    arrayTeams: array,
                                    arrayImages: arrayImages,
                                    isDataScraped: isScrapeDone)
                                .tableRow())
                  ],
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: Center(
          child: isScrapeDone && widget.globalData.isConnected
              ? table(context)
              : globals.wLoader),
    );
  }
}
