import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tex_markdown/tex_markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        onPressed: () {
          setState(() {
            _themeMode = (_themeMode == ThemeMode.dark)
                ? ThemeMode.light
                : ThemeMode.dark;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.onPressed});
  final VoidCallback? onPressed;

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextDirection _direction = TextDirection.ltr;
  final TextEditingController _controller = TextEditingController(text: r'''
# This is H1
## This is H2
### This is H3
#### This is H4
##### This is H5
###### This is H6

This are just regular text.
---
This is a image.
![300](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/800px-Image_created_with_a_mobile_phone.png)
**bold $x^2\cfrac a{\cfrac ab}$ text**
*Italic text $x^2\cfrac a{b}$*
**hello**
$hello$

$sdf \frac a{\frac ab}$
$hello$
[Link]()
- unordered list
1. ordered list 1
2. ordered list 2
(x) Radio checked
() Radio unchecked
[x] checkbox checked
[] Checkbox unchecked

| Name | Country |
| Sohag | Bangladesh |
''');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _direction = TextDirection.values[(_direction.index + 1) % 2];
              });
            },
            icon: const [Text("LTR"), Text("RTL")][_direction.index],
          ),
          IconButton(
            onPressed: widget.onPressed,
            icon: const Icon(Icons.sunny),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          return Material(
                            // color: Theme.of(context).colorScheme.surfaceVariant,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                reverse: _direction == TextDirection.rtl,
                                child: SizedBox(
                                  width: 400,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      textTheme: const TextTheme(
                                        // For H1.
                                        headlineLarge: TextStyle(fontSize: 55),
                                        // For H2.
                                        headlineMedium: TextStyle(fontSize: 45),
                                        // For H3.
                                        headlineSmall: TextStyle(fontSize: 35),
                                        // For H4.
                                        titleLarge: TextStyle(fontSize: 25),
                                        // For H5.
                                        titleMedium: TextStyle(fontSize: 15),
                                        // For H6.
                                        titleSmall: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    child: TexMarkdown(
                                      _controller.text,
                                      textDirection: _direction,
                                      onLinkTab: (url, title) {
                                        log(title, name: "title");
                                        log(url, name: "url");
                                      },
                                      style: const TextStyle(
                                        // Regular text font size here.
                                        fontSize: 15,
                                      ),
                                    ),
                                    // child: const Text("Hello"),
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Type here:")),
                    maxLines: null,
                    controller: _controller,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () async {
                String html = '''<!DOCTYPE html>
                    <html lang="en">
                    <head>
                    <meta charset="UTF-8"><title>markdown</title>
                    </head>
                    <body>
                    ${TexMarkdown.toHtml(_controller.text)}
                    </body>
                    </html>
                    ''';
                String? path = await FilePicker.platform.saveFile();
                if (path == null) {
                  return;
                }
                File(path).writeAsStringSync(html);
                launchUrlString(
                  "file:${Uri(
                    path: path,
                  ).path}",
                  mode: LaunchMode.externalApplication,
                );
              },
              icon: const Icon(Icons.html),
            ),
          ),
        ],
      ),
    );
  }
}
