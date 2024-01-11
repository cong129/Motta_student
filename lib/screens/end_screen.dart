import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:student/screens/calendar_page.dart';
import 'package:student/widgets/apis.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';

class EndScreen extends StatelessWidget {
  EndScreen({
    super.key,
    required this.studentId,
    required this.date,
  });

  final int studentId;
  final String date;
  final String text = "ぜんぶかくにんできたね\nすごいぞ!\nキャッホー";
  final AudioPlayer characterVoice = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final int id = studentId % 5 == 0 ? 5 : studentId % 5;

    Future<void> speak() async {
      postConfirmDate(date: date, studentId: studentId);

      await characterVoice.play(AssetSource('sounds/complete_char$id.wav'),
          volume: 1.0);

      final data = await getCalendarData(
        date: date,
        studentId: studentId,
      );

      characterVoice.onPlayerStateChanged.listen((event) {
        if (event == PlayerState.completed) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => CalendarPage(
                  data: data,
                  studentId: studentId,
                ),
              ),
            );
          });
        }
      });
    }

    speak();

    return Scaffold(
      appBar: AppBarMotta(studentId: studentId),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/char$id/end_background.PNG'), // 배경으로 사용할 이미지 경로
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/char$id/character_end.jpg"),
              BodyText(text: text),
            ],
          ),
        ),
      ),
    );
  }
}
