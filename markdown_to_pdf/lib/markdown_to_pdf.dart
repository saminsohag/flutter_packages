import 'dart:io';
import 'package:markdown/markdown.dart' as markdown;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

void convert(String text) {
  final file = File(inputPath);
  final markdownText = file.readAsStringSync();
}
