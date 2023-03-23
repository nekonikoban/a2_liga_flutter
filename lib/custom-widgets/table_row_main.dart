import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../_globals.dart';

class CustomMainTableRow extends StatefulWidget {
  final List<String> arrayTeams;
  final List<String> arrayImages;
  const CustomMainTableRow(
      {Key? key, required this.arrayTeams, required this.arrayImages})
      : super(key: key);

  @override
  State<CustomMainTableRow> createState() => _CustomMainTableRowState();
}

class _CustomMainTableRowState extends State<CustomMainTableRow> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
        horizontalMargin: 2.0,
        sortColumnIndex: 4,
        sortAscending: true,
        border: TableBorder.all(
            color: const Color.fromARGB(0, 255, 255, 255),
            borderRadius: BorderRadius.circular(20.0)),
        columnSpacing: 10.0,
        dataRowHeight: 70.0,
        headingRowHeight: 60.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
        ),
        columns: [
          DataColumn(
              tooltip: 'CLUB'.tr(),
              label: Text(
                ''.tr(),
                textAlign: TextAlign.center,
                style: Globals().textStyleSchedule,
              )),
          DataColumn(
              tooltip: 'TOTAL'.tr(),
              label: Text(
                'T'.tr(),
                textAlign: TextAlign.center,
                style: Globals().textStyleSchedule,
              )),
          DataColumn(
              tooltip: 'WINS'.tr(),
              label: Text(
                'W'.tr(),
                textAlign: TextAlign.center,
                style: Globals().textStyleSchedule,
              )),
          DataColumn(
              tooltip: 'LOSES'.tr(),
              label: Text(
                'L'.tr(),
                textAlign: TextAlign.center,
                style: Globals().textStyleSchedule,
              )),
          DataColumn(
            tooltip: 'SCORED'.tr(),
            label: Text(
              'S'.tr(),
              textAlign: TextAlign.center,
              style: Globals().textStyleSchedule,
            ),
            //TODO: FIX SORT IS NOT EXECUTING AS IT SHOULD (UNKNOWN BEHAVIOUR)
            onSort: (columnIndex, ascending) {
              /* print("SORTING COLUMN `S`");
              setState(() {
                if (ascending) {
                  widget.arrayTeams.sort(
                      (a, b) => b.split(',')[4].compareTo(a.split(',')[4]));
                } else {
                  widget.arrayTeams.sort(
                      (a, b) => a.split(',')[4].compareTo(b.split(',')[4]));
                }
              }); */
            },
          ),
          DataColumn(
              tooltip: 'CONCEDED'.tr(),
              label: Text(
                'C'.tr(),
                textAlign: TextAlign.center,
                style: Globals().textStyleSchedule,
              )),
          DataColumn(
              tooltip: 'DIFFERENCE'.tr(),
              label: Center(
                child: Text(
                  'D'.tr(),
                  textAlign: TextAlign.center,
                  style: Globals().textStyleSchedule,
                ),
              )),
          DataColumn(
              tooltip: 'POINTS'.tr(),
              label: Text(
                'P'.tr(),
                textAlign: TextAlign.center,
                style: Globals().textStyleSchedule,
              )),
        ],
        rows: [
          for (int i = 0; i < widget.arrayTeams.length; i++)
            DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (i > 3) {
                    return Colors.transparent;
                  } else {
                    return const Color.fromARGB(49, 33, 149, 243);
                  }
                }),
                cells: [
                  DataCell(
                      Center(
                        child: Image.asset(
                          'assets/${widget.arrayImages[i]}.png',
                          width: 23,
                          height: 23,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () => {
                            Globals().showTeamName(
                                widget.arrayTeams[i].split(',')[1])
                          }),
                  DataCell(
                    Center(
                        child: Text(
                      widget.arrayTeams[i].split(',')[2],
                      style: Globals().textStyleSchedule,
                    )),
                  ),
                  DataCell(
                    Center(
                        child: Text(
                      widget.arrayTeams[i].split(',')[3],
                      style: Globals().textStyleSchedule,
                    )),
                  ),
                  DataCell(
                    Center(
                        child: Text(
                      widget.arrayTeams[i].split(',')[4],
                      style: Globals().textStyleSchedule,
                    )),
                  ),
                  DataCell(
                    Center(
                        child: Text(
                      widget.arrayTeams[i].split(',')[5],
                      style: Globals().textStyleSchedule,
                    )),
                  ),
                  DataCell(
                    Center(
                        child: Text(
                      widget.arrayTeams[i].split(',')[6],
                      style: Globals().textStyleSchedule,
                    )),
                  ),
                  DataCell(
                    Center(
                        child: Text(
                      widget.arrayTeams[i].split(',')[7],
                      style: Globals().textStyleSchedule,
                    )),
                  ),
                  DataCell(
                    Center(
                        child: Text(
                      widget.arrayTeams[i].split(',')[8],
                      style: Globals().textStyleSchedule,
                    )),
                  ),
                ]),
        ]);
  }
}
