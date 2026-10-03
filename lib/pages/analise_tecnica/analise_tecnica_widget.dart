import 'package:flutter/material.dart';
import '../course/course_widget.dart';
export 'analise_tecnica_model.dart';

class AnaliseTecnicaWidget extends StatefulWidget {
  const AnaliseTecnicaWidget({super.key});

  static String routeName = 'AnaliseTecnica';
  static String routePath = '/analiseTecnica';

  @override
  State<AnaliseTecnicaWidget> createState() => _AnaliseTecnicaWidgetState();
}

class _AnaliseTecnicaWidgetState extends State<AnaliseTecnicaWidget> {
  @override
  Widget build(BuildContext context) {
    return const CourseWidget(courseId: 'analise_tecnica');
  }
}
