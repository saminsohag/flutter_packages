import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _controller = TextEditingController(text: r'''
# hi how are you?$my  is^2$
## hi how are you$(\frac ab)^2$?
### hi how are you?
#### hi how are you?
##### hi how are you?$my name is x^2$
###### hi how are you?$x^2$
hello
---
my name is
![100x100](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/800px-Image_created_with_a_mobile_phone.png)
**bold$x^2\cfrac a{\cfrac ab}$ text**
*Italic text$x^2\cfrac a{b}$*
**hello**
$hello$

$sdf\frac a{\frac ab}$
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
                          color: Colors.green,
                        ),
                      );
                    }),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Type here:")),
                    maxLines: null,
                    controller: _controller,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String html = '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><title>markdown</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css" integrity="sha384-zB1R0rpPzHqg7Kpt0Aljp8JPLqbXI3bhnPWROx27a9N0Ll6ZP/+DiW/UqRcLbRjq" crossorigin="anonymous">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js" integrity="sha384-y23I5Q6l+B6vatafAwxRu/0oK/79VlbSz7Q9aiSZUvyWYIYsd+qj+o24G5ZU2zJz" crossorigin="anonymous"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/contrib/auto-render.min.js" integrity="sha384-kWPLUVMOks5AQFrykwIup5lo0m3iMkkHrD0uJ4H5cjeGihAutqP0yW0J6dpFiVkI" crossorigin="anonymous" onload="renderMathInElement(document.body);"></script>
</head>
<body>
${TexMarkdown.toHtml(_controller.text)}
</body>
</html>
''';
                    Clipboard.setData(ClipboardData(text: html));
                  },
                  icon: const Icon(Icons.html),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
