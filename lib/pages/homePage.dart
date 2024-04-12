import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naliv_shifts_naliv/api.dart';
import 'package:naliv_shifts_naliv/pages/loginPage.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<TableCell> _tableCells = [];
  Map<String, dynamic> employees = {};
  List<String> employeeList = [];

  List<TableRow> _tableRows = [];

  List _shifts = [];
  _getShifts(int month, int year) async {
    List shifts = await getShifts(month, year);
    setState(() {
      _shifts = shifts;
    });
    for (int i = 0; i < _shifts.length; i++) {
      // if (_shifts[i]["started_at"] != null) {
      //   print("STARTED AT: ${_shifts[i]["started_at"]}");
      // }
      if (employeeList.contains(_shifts[i]['employee_id'])) {
        employees.update(_shifts[i]['employee_id'], (value) {
          if (_shifts[i]["started_at"] != null) {
            return {
              "fullname":
                  "${_shifts[i]["first_name"]} ${_shifts[i]["last_name"] ?? ""}",
              "shifts_amount": value["shifts_amount"] + 1,
              "shifts_worked": value["shifts_worked"] + 1,
            };
          } else {
            return {
              "fullname":
                  "${_shifts[i]["first_name"]} ${_shifts[i]["last_name"] ?? ""}",
              "shifts_amount": value["shifts_amount"] + 1,
              "shifts_worked": value["shifts_worked"],
            };
          }
        });
      } else {
        employeeList.add(_shifts[i]['employee_id']);
        employees.addAll(
          {
            _shifts[i]['employee_id']: {
              "fullname":
                  "${_shifts[i]["first_name"]} ${_shifts[i]["last_name"] ?? ""}",
              "shifts_amount": 1,
              "shifts_worked": 1,
            },
          },
        );
      }
      // _tableCells.add(
      //   TableCell(
      //     child: Container(
      //       child: Text(
      //         _shifts[i]["shift_id"],
      //         style: const TextStyle(color: Colors.black),
      //       ),
      //     ),
      //   ),
      // );
    }
    setState(
      () {
        _tableRows = List.generate(
          employeeList.length,
          (index) => TableRow(
            children: [
              TableCell(
                child: Container(
                  child: Text(
                    employees[employeeList[index]]["fullname"] ?? "Нет имени",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  child: Text(
                    employees[employeeList[index]]["shifts_amount"].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  child: Text(
                    employees[employeeList[index]]["shifts_worked"].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: FloatingActionButton(
          onPressed: () {
            showMonthPicker(
              context: context,
              initialDate: DateTime.now(),
            ).then((date) {
              _getShifts(date!.month, date.year);
            });
          },
          child: const Icon(
            Icons.calendar_today,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        shadowColor: Colors.black38,
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginPage(
                      fromHomePage: true,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).colorScheme.primary,
              child: _tableRows.isEmpty
                  ? Table(
                      border: TableBorder.all(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                      ),
                      columnWidths: const {1: FlexColumnWidth(1.0)},
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Table(
                        border: TableBorder.all(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                        ),
                        defaultColumnWidth: const FixedColumnWidth(50.0),
                        children: _tableRows,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
