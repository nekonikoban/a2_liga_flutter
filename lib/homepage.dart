import 'package:a2_league/custom-widgets/bounce_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import '_globals.dart';
import 'custom-widgets/table_row_main.dart';

class MainTableWidget extends StatefulWidget {
  final List<String> array;
  const MainTableWidget({Key? key, required this.array}) : super(key: key);
  @override
  State<MainTableWidget> createState() => _MainTableWidgetState();
}

class _MainTableWidgetState extends State<MainTableWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //SCREENSHOT
  GlobalKey previewContainer = GlobalKey();
  int originalSize = 2400;

  shareScreenshot() async {
    Globals().loadingDialog('Making Screenshot'.tr(), context);
    await ShareFilesAndScreenshotWidgets().shareScreenshot(previewContainer,
        originalSize, "Table".tr(), "a2liga_tabela.png", "image/png",
        text: "Tabela");
    return true;
  }

  Widget table(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RepaintBoundary(
            key: previewContainer,
            child: CustomMainTableRow(arrayTeams: widget.array),
          ),
          const SizedBox(height: 1),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    color: const Color.fromARGB(47, 33, 243, 79),
                    width: 30,
                    height: 15),
                const SizedBox(width: 5),
                Text('Promotion'.tr(), style: Globals().textStyleSchedule),
                const SizedBox(width: 20),
                Container(
                    color: const Color.fromARGB(49, 33, 149, 243),
                    width: 30,
                    height: 15),
                const SizedBox(width: 5),
                Text('Play-off'.tr(), style: Globals().textStyleSchedule),
              ]),
          const SizedBox(width: 5),
          const SizedBox(height: 20),
          BounceWidget(
              text: '',
              color: Colors.blue,
              shape: BoxShape.circle,
              icon: const Icon(Icons.share_outlined),
              onPressed: () async => {await shareScreenshot()}),
          const SizedBox(height: 20),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: Center(child: table(context)),
    );
  }
}
