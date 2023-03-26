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

  int teamID = 0, teamIndexBlur = -1;
  List<String> array = [], arrayImages = [];
  List<String> arrayTeamSchedule = [], arrayTeamScheduleImages = [];
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

  void animateToTopOfScreen() {
    _scrollController.animateTo(
      //Force scroll to the bottom
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 2500),
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
            //TEAMS
            Text(
              'Tap a team to display'.tr(),
              style: TextStyle(
                  fontFamily: globals.fontFam,
                  fontSize: 20,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            for (int i = 0; i < 3; i++) globals.devider20,
            SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    globals.numOfTeams,
                    (index) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: index == teamIndexBlur
                                  ? Colors.blue.withOpacity(0.5)
                                  : Colors.transparent,
                              spreadRadius: 10,
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width / 5,
                        height: MediaQuery.of(context).size.height % 100,
                        child: GestureDetector(
                            child: Transform.scale(
                                scale: 2.0,
                                child: Image.asset(
                                    filterQuality: FilterQuality.high,
                                    'assets/${arrayImages[index]}.png')),
                            onTap: () async {
                              teamIndexBlur = teamID = index;
                              if (widget.globalData.isConnected) {
                                await globals.scrapeTeamSchedule(
                                    arrayTeamSchedule,
                                    arrayTeamScheduleImages,
                                    index + 1);
                                setState(() => {isTeamTapped = true});
                                Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () => {animateToBottomOfScreen()});
                              } else {
                                globals.showMessage('NO INTERNET'.tr());
                              }
                            })),
                  ),
                )),
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
                      FloatingActionButton(
                        onPressed: () => {animateToTopOfScreen()},
                        backgroundColor: globals.glowColor.withOpacity(0.25),
                        child:
                            const Icon(Icons.arrow_upward_outlined, size: 20),
                      ),
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
