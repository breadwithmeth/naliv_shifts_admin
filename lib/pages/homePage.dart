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

  Map<String, dynamic> employeesWithShifts = {};
  List<String> employeeList = [];

  // List<TableRow> _tableRows = [];
  // Map<String, dynamic> shiftsBydays = {};

  List _shifts = [];

  _getShifts(int month, int year) async {
    List shifts = await getShifts(month, year);
    setState(() {
      _shifts = shifts;
    });
    for (int i = 0; i < _shifts.length; i++) {
      if (!employeeList.contains("${_shifts[i]['employee_id']}")) {
        employeeList.add("${_shifts[i]['employee_id']}");
      }
      if (employeesWithShifts.keys.contains("${_shifts[i]['employee_id']}")) {
        employeesWithShifts.update(
          "${_shifts[i]['employee_id']}",
          (value) => {
            "fullname": value["fullname"],
            "shifts": [...value["shifts"], _shifts[i]],
            "shifts_amount": value["shifts_amount"] + 1,
            "shifts_worked": value["shifts_worked"] +
                ((_shifts[i]["started_at"] != null) ? 1 : 0),
            "departament_name": value["departament_name"],
          },
        );
        // print(
        //     "EMPLOYEE: ${_shifts[i]['first_name']} ${_shifts[i]['last_name']}");
      }
      employeesWithShifts.addAll({
        "${_shifts[i]['employee_id']}": {
          "fullname":
              "${_shifts[i]["first_name"]} ${_shifts[i]["last_namе"] ?? ''}",
          "shifts": [_shifts[i]],
          "shifts_amount": 1,
          "shifts_worked": ((_shifts[i]["started_at"] != null) ? 1 : 0),
          "departament_name": _shifts[i]["departament_name"],
        }
      });
    }
    //   for (int i = 0; i < _shifts.length; i++) {
    //     // if (_shifts[i]["started_at"] != null) {
    //     //   print("STARTED AT: ${_shifts[i]["started_at"]}");
    //     // }
    //     if (employeeList.contains(_shifts[i]['employee_id'])) {
    //       employees.update(_shifts[i]['employee_id'], (value) {
    //         if (_shifts[i]["started_at"] != null) {
    //           return {
    //             "fullname":
    //                 "${_shifts[i]["first_name"]} ${_shifts[i]["last_name"] ?? ""}",
    //             "shifts_amount": value["shifts_amount"] + 1,
    //             "shifts_worked": value["shifts_worked"] + 1,
    //           };
    //         } else {
    //           return {
    //             "fullname":
    //                 "${_shifts[i]["first_name"]} ${_shifts[i]["last_name"] ?? ""}",
    //             "shifts_amount": value["shifts_amount"] + 1,
    //             "shifts_worked": value["shifts_worked"],
    //           };
    //         }
    //       });
    //     } else {
    //       employeeList.add(_shifts[i]['employee_id']);
    //       employees.addAll(
    //         {
    //           _shifts[i]['employee_id']: {
    //             "fullname":
    //                 "${_shifts[i]["first_name"]} ${_shifts[i]["last_name"] ?? ""}",
    //             "shifts_amount": 1,
    //             "shifts_worked": 1,
    //           },
    //         },
    //       );
    //     }
    //     // _tableCells.add(
    //     //   TableCell(
    //     //     child: Container(
    //     //       child: Text(
    //     //         _shifts[i]["shift_id"],
    //     //         style: const TextStyle(color: Colors.black),
    //     //       ),
    //     //     ),
    //     //   ),
    //     // );
    //   }
    //   setState(
    //     () {
    //       List<TableRow> temp = List.generate(
    //         employeeList.length,
    //         (index) => TableRow(
    //           children: [
    //             TableCell(
    //               child: Container(
    //                 child: Text(
    //                   employees[employeeList[index]]["fullname"] ?? "Нет имени",
    //                   style: const TextStyle(color: Colors.black),
    //                 ),
    //               ),
    //             ),
    //             TableCell(
    //               child: Container(
    //                 child: Text(
    //                   employees[employeeList[index]]["shifts_amount"].toString(),
    //                   style: const TextStyle(color: Colors.black),
    //                 ),
    //               ),
    //             ),
    //             TableCell(
    //               child: Container(
    //                 child: Text(
    //                   employees[employeeList[index]]["shifts_worked"].toString(),
    //                   style: const TextStyle(color: Colors.black),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //       _tableRows.add(
    //         TableRow(
    //           children: List.generate(
    //             24,
    //             (index) {
    //               return TableCell(
    //                 child: Container(
    //                   child: Text(
    //                     index.toString(),
    //                   ),
    //                 ),
    //               );
    //             },
    //           ),
    //         ),
    //       );
    //       _tableRows.addAll(temp);
    //     },
    //   );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Flexible(
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
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 10,
            fit: FlexFit.tight,
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Theme.of(context).colorScheme.primary,
                    child: employeesWithShifts.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(15),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  employeesWithShifts.keys.length,
                                  (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                employeesWithShifts[
                                                            employeeList[index]]
                                                        ["fullname"] ??
                                                    "Нет имени",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Flexible(
                                              child: Text(
                                                employeesWithShifts[
                                                            employeeList[index]]
                                                        ["departament_name"] ??
                                                    "Нет отдела",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  Row(
                                    children: List.generate(
                                      25,
                                      (index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 35,
                                            vertical: 15,
                                          ),
                                          child: Container(
                                            child: Text(
                                              "${index == 0 ? 24 : index} ч.",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: List.generate(
                                  //     1,
                                  //     (index) {
                                  //       return Padding(
                                  //         padding: const EdgeInsets.symmetric(
                                  //           horizontal: 15,
                                  //           vertical: 15,
                                  //         ),
                                  //         child: Container(
                                  //           child: Row(
                                  //             children: [
                                  //               Flexible(
                                  //                 child: Text(
                                  //                   "Иванов Инван",
                                  //                   overflow: TextOverflow.ellipsis,
                                  //                   style: TextStyle(
                                  //                     color: Theme.of(context)
                                  //                         .colorScheme
                                  //                         .onPrimary,
                                  //                     fontSize: 18,
                                  //                     fontWeight: FontWeight.w700,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //               const SizedBox(
                                  //                 width: 15,
                                  //               ),
                                  //               Flexible(
                                  //                 child: Text(
                                  //                   "Нет отдела",
                                  //                   overflow: TextOverflow.ellipsis,
                                  //                   style: TextStyle(
                                  //                     color: Theme.of(context)
                                  //                         .colorScheme
                                  //                         .onPrimary,
                                  //                     fontSize: 18,
                                  //                     fontWeight: FontWeight.w500,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            // child: _tableRows.isEmpty
            //     ? Table(
            //         border: TableBorder.all(
            //           borderRadius:
            //               const BorderRadius.all(Radius.circular(3)),
            //         ),
            //         columnWidths: const {1: FlexColumnWidth(1.0)},
            //         children: [
            //           TableRow(
            //             children: [
            //               TableCell(
            //                 child: Container(
            //                   color: Colors.amber,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       )
            //     : SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: Table(
            //           border: TableBorder.all(
            //             borderRadius:
            //                 const BorderRadius.all(Radius.circular(3)),
            //           ),
            //           defaultColumnWidth: const FixedColumnWidth(50.0),
            //           children: _tableRows,
            //         ),
            //       ),
          ),
        ],
      ),
    );
  }
}
