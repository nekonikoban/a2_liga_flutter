import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'custom-widgets/table_row_main.dart';

class MainTableWidget extends StatefulWidget {
  final List<String> array;
  final List<String> arrayImages;
  const MainTableWidget(
      {Key? key, required this.array, required this.arrayImages})
      : super(key: key);
  @override
  _MainTableWidgetState createState() => _MainTableWidgetState();
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
            arrayImages: widget.arrayImages,
            arrayTeams: widget.array,
          ),
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