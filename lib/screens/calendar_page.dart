import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student/models/calendar_model.dart';
import 'package:student/screens/student_login.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/elevated_button_with_style.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage(
      {super.key,
      required this.data,
      required this.studentId,
      required this.bgmController});

  final List<dynamic> data;
  final int studentId;
  final AudioPlayer bgmController;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late List _data;
  late int _studentId;
  late AudioPlayer _bgmController;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _studentId = widget.studentId;
    _bgmController = widget.bgmController;
  }

  @override
  Widget build(BuildContext context) {
    final int id = _studentId % 5 == 0 ? 5 : _studentId % 5;
    return PopScope(
      onPopInvoked: (didPop) {
        _bgmController.stop();
      },
      child: ChangeNotifierProvider<CalendarModel>(
        create: (_) => CalendarModel()..init(),
        child: Consumer<CalendarModel>(builder: (context, model, snapshot) {
          return Scaffold(
            appBar: AppBarMotta(studentId: _studentId),
            body: Container(
              color: const Color.fromARGB(255, 232, 241, 243),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TableCalendar<dynamic>(
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 116, 116, 116),
                          ),
                          weekendStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 237, 21, 21),
                          ),
                          dowTextFormatter: (date, locale) {
                            switch (date.weekday) {
                              case 1:
                                return "げつ";
                              case 2:
                                return "か";
                              case 3:
                                return "すい";
                              case 4:
                                return "もく";
                              case 5:
                                return "きん";
                              case 6:
                                return "ど";
                              case 7:
                                return "にち";
                              default:
                                return "";
                            }
                          },
                        ),
                        focusedDay: DateTime.now(),
                        // focusedDay: DateTime(2024, 1, 10),
                        firstDay: DateTime.utc(2022, 4, 1),
                        lastDay: DateTime.utc(2025, 12, 31),
                        locale: Localizations.localeOf(context).languageCode,
                        rowHeight: 120,
                        daysOfWeekHeight: 60,
                        headerStyle: HeaderStyle(
                          titleTextStyle: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 52, 51, 51)),
                          titleTextFormatter: (date, locale) {
                            return DateFormat("yyyyねん Mがつ", locale)
                                .format(date);
                          },
                          titleCentered: true,
                          formatButtonVisible: false,
                          leftChevronVisible: true,
                          rightChevronVisible: true,
                        ),
                        calendarStyle: const CalendarStyle(
                          defaultTextStyle: TextStyle(fontSize: 21),
                          isTodayHighlighted: true,
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, date, events) {
                            return Container(
                              margin: const EdgeInsets.all(2.0),
                              alignment: Alignment.topLeft,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5),
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        date.weekday == 6 || date.weekday == 7
                                            ? Colors.red
                                            : const Color.fromARGB(
                                                255, 116, 116, 116),
                                  ),
                                ),
                              ),
                            );
                          },
                          outsideBuilder: (context, day, focusedDay) {
                            return Container(
                              margin: const EdgeInsets.all(2.0),
                              alignment: Alignment.topLeft,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(85, 255, 255, 255),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5),
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 211, 208, 208),
                                  ),
                                ),
                              ),
                            );
                          },
                          todayBuilder: (context, day, focusedDay) {
                            return Container(
                              margin: const EdgeInsets.all(2.0),
                              alignment: Alignment.topLeft,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 243, 128, 21),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5),
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            );
                          },
                          markerBuilder: (context, date, events) {
                            String dateOnly =
                                DateFormat("yyyy-MM-dd").format(date);
                            if (widget.data.contains(dateOnly)) {
                              return Positioned(
                                top: 1,
                                child: Image.asset(
                                    'assets/images/stamps/char$id.PNG'),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    SizedBox(
                      height: 100,
                      child: ElevatedButtonWithStyle(
                        "さいしょにもどる",
                        studentId: widget.studentId,
                        () {
                          widget.bgmController.stop();
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
