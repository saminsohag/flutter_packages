import 'package:flutter/material.dart';
import 'package:tex_markdown/tex_markdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
                        style: const TextStyle(
                          color: Colors.red,
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
