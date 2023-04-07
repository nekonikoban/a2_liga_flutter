import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../_globals.dart';

class CustomTeamTableRow extends TableRow {
  final List<String> arrayTeams;
  final List<String> arrayImages;
  final bool isDataScraped;

  const CustomTeamTableRow({
    required this.arrayTeams,
    required this.arrayImages,
    required this.isDataScraped,
  });

  tableRow() {
    return isDataScraped
        ? DataTable(
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
                  'DATE'.tr(),
                  textAlign: TextAlign.center,
                  style: Globals().textStyleSchedule,
                )),
                DataColumn(
                    label: Text(
                  'H',
                  textAlign: TextAlign.center,
                  style: Globals().textStyleSchedule,
                )),
                DataColumn(
                    label: Text(
                  'A',
                  textAlign: TextAlign.center,
                  style: Globals().textStyleSchedule,
                )),
                DataColumn(
                    label: Text(
                  'R',
                  textAlign: TextAlign.center,
                  style: Globals().textStyleSchedule,
                )),
              ],
            rows: [
                for (int i = 0; i < arrayTeams.length; i++)
                  DataRow(cells: [
                    DataCell(Text(
                      arrayTeams[i].split(',')[1],
                      textAlign: TextAlign.center,
                      style: Globals().textStyleSchedule,
                    )),
                    DataCell(
                      Image.asset(
                        i <= 0
                            ? 'assets/${arrayImages[i]}.png'
                            : 'assets/${arrayImages[i * 2]}.png',
                      ),
                    ),
                    DataCell(
                      Image.asset(
                        i <= 0
                            ? 'assets/${arrayImages[i + 1]}.png'
                            : 'assets/${arrayImages[i * 2 + 1]}.png',
                      ),
                    ),
                    DataCell(Text(
                      "${arrayTeams[i].split(',')[7]} : ${arrayTeams[i].split(',')[9]}",
                      textAlign: TextAlign.center,
                      style: Globals().textStyleSchedule,
                    )),
                  ]),
              ])
        : Container();
  }
}
