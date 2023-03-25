import 'package:a2_league/_global_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import '_globals.dart';
import 'custom-widgets/table_row_team.dart';

class TeamsScreen extends StatefulWidget {
  final GlobalData globalData;
  const TeamsScreen({Key? key, required this.globalData}) : super(key: key);
  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final globals = Globals();

  int teamID = 0;
  List<String> array = [];
  List<String> arrayImages = [];
  List<String> arrayTeamSchedule = [];
  List<String> arrayTeamScheduleImages = [];
  String teamGraph = '';
  bool isInitDone = false;
  bool isScrapeDone = false;
  bool isTeamTapped = false;
  bool isGraphScraped = false;
  //CHANGING COLOR DEPENDING IF USER IS TAPPING THE TEAM
  GlobalKey widgetKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool isTapUp = true;

  @override
  void initState() {
    super.initState();

    array = globals.initTeamNames(array);
    arrayImages = globals.initTeamImages(arrayImages);
    setState(() => {isInitDone = true});

    //LISTEN TO CONNECTION CHANGE
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      widget.globalData
          .updateConnectionStatus(result != ConnectivityResult.none);
      if (!widget.globalData.isConnected) {
        globals.showMessage('NO INTERNET'.tr());
      }
    });

    /* initTeamData().then((value) => {
          setState(() => {isInitDone = true}),
          scrapeTeamGraphURL(1)
        }); */
  }

  void animateToBottomOfScreen() {
    _scrollController.animateTo(
      //Force scroll to the bottom
      _scrollController.position.maxScrollExtent * 20,
      duration: const Duration(milliseconds: 5000),
      curve: Curves.easeInOut,
    );
  }

  Widget table(BuildContext context) {
    return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            globals.devider20,
            //TEAM TABLE
            DataTable(
                sortColumnIndex: 0,
                border: TableBorder.all(
                    color: const Color.fromARGB(23, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20.0)),
                columnSpacing: 10.0,
                dataRowHeight: 50.0,
                headingRowHeight: 60.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                columns: [
                  DataColumn(
                      label: Text(
                    'LOGO',
                    textAlign: TextAlign.center,
                    style: Globals().textStyleSchedule,
                  )),
                  DataColumn(
                      label: Text(
                    'NAME'.tr(),
                    textAlign: TextAlign.center,
                    style: Globals().textStyleSchedule,
                  )),
                ],
                rows: [
                  for (int i = 0; i < array.length; i++) // x4
                    DataRow(cells: [
                      DataCell(
                        Image.asset('assets/${arrayImages[i]}.png'),
                      ),
                      DataCell(
                        Text(
                          array[i],
                          textAlign: TextAlign.start,
                          style: Globals().textStyleSchedule,
                        ),
                        onTap: () async {
                          teamID = i;
                          if (widget.globalData.isConnected) {
                            await globals.scrapeTeamSchedule(arrayTeamSchedule,
                                arrayTeamScheduleImages, i + 1);
                            setState(() => {isTeamTapped = true});
                            animateToBottomOfScreen();
                          } else {
                            globals.showMessage('NO INTERNET'.tr());
                          }
                        },
                      ),
                    ]),
                ]),
            for (int i = 0; i < 2; i++) globals.devider20,
            //SHOW SCHEDULE OF A TEAM ON TAPP
            isTeamTapped
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      globals.devider20,
                      Center(
                          child: Text(array[teamID],
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white))),
                      globals.devider20,
                      Container(
                          key: widgetKey,
                          child: CustomTeamTableRow(
                                  arrayTeams: arrayTeamSchedule,
                                  arrayImages: arrayTeamScheduleImages,
                                  isDataScraped: isTeamTapped)
                              .tableRow()),
                      globals.devider20,
                      /* isGraphScraped
                          ? Column(
                              children: [
                                Text(teamGraph),
                                Container(
                                    color: Colors.orangeAccent,
                                    child: Image.network(teamGraph))
                              ],
                            )
                          : Container(),
                      globals.devider20, */
                    ],
                  )
                : Container()
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: Center(child: isInitDone ? table(context) : globals.wLoader),
    );
  }
}
