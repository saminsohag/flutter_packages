This is a flutter package to create markdown widget. with Latex math formula support and also simple to use package.

## Features

You can create simple markdown view by this package.

At this moment this package supports:
* Unordered list 

        `* <Text here>`
* Links 

        `[<text here>](<href>)`
* Images with size 

        `![<width>x<hight> someText](url)`
* Table

    ```
    | Name | Roll |
    | sohag | 1   |

    ```
    | Name      | Roll |
    |-------------|-------------|
    | sohag      | 1       |

* Bolt texts

        `**<Text here>**`
* heading texts 

        `## <Text here>`
* Latex formula 

        `$\frac a b$`

    $\frac a b$

## Getting started

Run this command:
```
flutter pub add tex_markdown 
```

## Usage

Check the documentation [here.](https://github.com/saminsohag/flutter_packages/tree/main/tex_markdown/example)

```dart
import 'package:flutter/material.dart';
import 'package:tex_markdown/tex_markdown.dart';

return TexMarkdown(
    '''
    * This is a unordered list.
    ''',
    style: const TextStyle(
    color: Colors.red,
),

```

## Additional information

You can find the source code [here.](https://github.com/saminsohag/flutter_packages/tree/main/tex_markdown)