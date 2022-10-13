import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../Provider/homeProvider.dart';

class AppBarCalendar extends StatefulWidget {
  const AppBarCalendar({Key? key}) : super(key: key);

  @override
  State<AppBarCalendar> createState() => _AppBarCalendarState();
}

Map<String, String> weekDays = {
  "Mon": "Lun",
  "Tue": "Mar",
  "Wed": "Mie",
  "Thu": "Jue",
  "Fri": "Vie",
  "Sat": "Sab",
  "Sun": "Dom"
};

class _AppBarCalendarState extends State<AppBarCalendar> {
  int selectedIndex = 0;
  DateTime now = DateTime.now();
  final ItemScrollController _scrollController = ItemScrollController();
  late DateTime lastDayOfMonth;
  @override
  void initState() {
    super.initState();
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final agendaPro = Provider.of<AgendaProvider>(context);
    return ScrollablePositionedList.builder(
      initialScrollIndex: now.day - 1,
      scrollDirection: Axis.horizontal,
      itemScrollController: _scrollController,
      itemCount: lastDayOfMonth.day,
      itemBuilder: (BuildContext context, i) {
        final currentDate = DateTime(now.year, now.month, i + 1);
        final dayName = DateFormat('E').format(currentDate);
        return Padding(
          padding: EdgeInsets.only(
              left: i == 0 ? media.width * 0.04 : 0.0,
              right: media.width * 0.04),
          child: GestureDetector(
            onTap: () => setState(() {
              selectedIndex = i;
              // TODO: Tomar los datos de la fecha seleccionada y envialos al gestor de datos (Provider)
              print("${currentDate} : $dayName");
              agendaPro.daySelected(currentDate);
            }),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: media.height * 0.08,
                  width: media.height * 0.06,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ((selectedIndex == i && selectedIndex != 0) ||
                            (now.day - 1 == i && selectedIndex == 0))
                        ? Colors.orange
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        weekDays[dayName]!,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: ((selectedIndex == i && selectedIndex != 0) ||
                                  (now.day - 1 == i && selectedIndex == 0))
                              ? Colors.white
                              : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${i + 1}",
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    // return Column(
    //   children: [
    //     // const SizedBox(height: 16.0),
    //     SingleChildScrollView(
    //       scrollDirection: Axis.horizontal,
    //       physics: const ClampingScrollPhysics(),
    //       child: Row(
    //         children: List.generate(
    //           lastDayOfMonth.day,
    //           (index) {
    //             final currentDate =
    //                 lastDayOfMonth.add(Duration(days: index + now.day));
    //             final dayName = DateFormat('E').format(currentDate);
    //             return Padding(
    //               padding: EdgeInsets.only(
    //                   left: index == 0 ? media.width * 0.04 : 0.0,
    //                   right: media.width * 0.04),
    //               child: GestureDetector(
    //                 onTap: () => setState(() {
    //                   selectedIndex = index;
    //                 }),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Container(
    //                       height: media.height * 0.08,
    //                       width: media.height * 0.06,
    //                       alignment: Alignment.center,
    //                       decoration: BoxDecoration(
    //                         color: (selectedIndex == index)
    //                             ? Colors.orange
    //                             : Colors.transparent,
    //                         borderRadius: BorderRadius.circular(15.0),
    //                       ),
    //                       child: Column(
    //                         children: [
    //                           Text(
    //                             weekDays[dayName]!,
    //                             style: TextStyle(
    //                               fontSize: 16.0,
    //                               color: selectedIndex == index
    //                                   ? Colors.white
    //                                   : Colors.black54,
    //                               fontWeight: FontWeight.bold,
    //                             ),
    //                           ),
    //                           Text(
    //                             "${index + 1}",
    //                             style: const TextStyle(
    //                               fontSize: 16.0,
    //                               color: Colors.black54,
    //                               fontWeight: FontWeight.bold,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
