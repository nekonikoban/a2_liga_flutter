import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
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

  Widget table(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomMainTableRow(
            arrayTeams: widget.array,
          ),
          /* const SizedBox(height: 20),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    color: const Color.fromARGB(47, 33, 243, 79),
                    width: 25,
                    height: 10,
                    child: Text('Promotion'.tr())),
                const SizedBox(width: 20),
                Container(
                    color: const Color.fromARGB(49, 33, 149, 243),
                    width: 25,
                    height: 10,
                    child: Text('Play-off'.tr())),
              ]) */
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
