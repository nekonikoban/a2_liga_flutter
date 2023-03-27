import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../_globals.dart';

class CustomMainTableRow extends StatefulWidget {
  final List<String> arrayTeams;
  const CustomMainTableRow({Key? key, required this.arrayTeams})
      : super(key: key);

  @override
  State<CustomMainTableRow> createState() => _CustomMainTableRowState();
}

class _CustomMainTableRowState extends State<CustomMainTableRow> {
  bool isSorted = false;
  List<String> sortedArray = [];
  void sort(array, index) {
    List<String> sorted = [];
    sorted.addAll(array);
    sorted.sort((a, b) => int.parse(b.split(',')[index])
        .compareTo(int.parse(a.split(',')[index])));

    setState(() => {sortedArray.addAll(sorted), isSorted = true});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 750),
        child: DataTable(
            key: UniqueKey(),
            horizontalMargin: 2.0,
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
                  label: isSorted
                      ? GestureDetector(
                          child: Icon(
                            Icons.restore_outlined,
                            color: Globals().glowColor,
                          ),
                          onTap: () => {
                                setState(() =>
                                    {sortedArray.clear(), isSorted = false})
                              })
                      : const Text('')),
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
                onSort: (columnIndex, ascending) {
                  if (!isSorted) sort(widget.arrayTeams, columnIndex + 1);
                },
              ),
              DataColumn(
                tooltip: 'CONCEDED'.tr(),
                label: Text(
                  'C'.tr(),
                  textAlign: TextAlign.center,
                  style: Globals().textStyleSchedule,
                ),
                onSort: (columnIndex, ascending) {
                  if (!isSorted) sort(widget.arrayTeams, columnIndex + 1);
                },
              ),
              DataColumn(
                tooltip: 'DIFFERENCE'.tr(),
                label: Center(
                  child: Text(
                    'D'.tr(),
                    textAlign: TextAlign.center,
                    style: Globals().textStyleSchedule,
                  ),
                ),
                onSort: (columnIndex, ascending) {
                  if (!isSorted) sort(widget.arrayTeams, columnIndex + 1);
                },
              ),
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
                      if (i > 3 || isSorted) {
                        return Colors.transparent;
                      } else if (i == 0 || i == 1) {
                        return const Color.fromARGB(47, 33, 243, 79);
                      } else if (i == 2 || i == 3) {
                        return const Color.fromARGB(49, 33, 149, 243);
                      }
                    }),
                    cells: [
                      DataCell(
                          Center(
                            child: Image.asset(
                              'assets/${isSorted ? sortedArray[i].split(',')[1] : widget.arrayTeams[i].split(',')[1]}.png',
                              width: 23,
                              height: 23,
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () => {
                                Globals().showTeamName(isSorted
                                    ? sortedArray[i].split(',')[1]
                                    : widget.arrayTeams[i].split(',')[1])
                              }),
                      DataCell(
                        Center(
                            child: Text(
                          isSorted
                              ? sortedArray[i].split(',')[2]
                              : widget.arrayTeams[i].split(',')[2],
                          style: Globals().textStyleSchedule,
                        )),
                      ),
                      DataCell(
                        Center(
                            child: Text(
                          isSorted
                              ? sortedArray[i].split(',')[3]
                              : widget.arrayTeams[i].split(',')[3],
                          style: Globals().textStyleSchedule,
                        )),
                      ),
                      DataCell(
                        Center(
                            child: Text(
                          isSorted
                              ? sortedArray[i].split(',')[4]
                              : widget.arrayTeams[i].split(',')[4],
                          style: Globals().textStyleSchedule,
                        )),
                      ),
                      DataCell(
                        Center(
                            child: Text(
                          isSorted
                              ? sortedArray[i].split(',')[5]
                              : widget.arrayTeams[i].split(',')[5],
                          style: Globals().textStyleSchedule,
                        )),
                      ),
                      DataCell(
                        Center(
                            child: Text(
                          isSorted
                              ? sortedArray[i].split(',')[6]
                              : widget.arrayTeams[i].split(',')[6],
                          style: Globals().textStyleSchedule,
                        )),
                      ),
                      DataCell(
                        Center(
                            child: Text(
                          isSorted
                              ? sortedArray[i].split(',')[7]
                              : widget.arrayTeams[i].split(',')[7],
                          style: Globals().textStyleSchedule,
                        )),
                      ),
                      DataCell(
                        Center(
                            child: Text(
                          isSorted
                              ? sortedArray[i].split(',')[8]
                              : widget.arrayTeams[i].split(',')[8],
                          style: Globals().textStyleSchedule,
                        )),
                      ),
                    ]),
            ]));
  }
}
