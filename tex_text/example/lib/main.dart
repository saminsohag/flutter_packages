import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:tex_text/tex_text.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _text = TextEditingController(
      text: r"Some random text and $x^2+y^2=$ some thing");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
          "Tex Text .",
          textDirection: TextDirection.rtl,
        )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  AnimatedBuilder(
                      animation: _text,
                      builder: (context, child) {
                        return Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(width: 1),
                          ),
                          child: TexText(
                            // TexText.newEasySyntax(_text.text),
                            _text.text,
                            textDirection: TextDirection.rtl,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.blue,
                                ),
                            mathStyle: MathStyle.displayCramped,
                          ),
                        );
                      }),
                ],
              ),
            ),
            TextField(
              controller: _text,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            Builder(builder: (context) {
              return FilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      children: [
                        SelectableText(TexText.toHtmlData((_text.text)))
                      ],
                    ),
                  );
                },
                child: const Text("To html"),
              );
            })
          ],
        ),
      ),
    );
  }
}
