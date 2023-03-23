import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tex_markdown/tex_markdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
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
            _themeMode = ThemeMode.values[(_themeMode.index + 1) % 3];
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
  final TextEditingController _controller =
      TextEditingController(text: '''# hi how are you?
## hi how are you?
### hi how are you?
#### hi how are you?
##### hi how are you?
###### hi how are you?
![100x100](https://image.jpg)
---
**bold text**
*Italic text*
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
            onPressed: widget.onPressed,
            icon: const Icon(Icons.sunny),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return TexMarkdown(
                        _controller.text,
                        onLinkTab: (url, title) {
                          log(title, name: "title");
                          log(url, name: "url");
                        },
                        style: const TextStyle(
                            // color: Colors.red,
                            ),
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
                    border: OutlineInputBorder(), label: Text("Type here:")),
                maxLines: null,
                controller: _controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
