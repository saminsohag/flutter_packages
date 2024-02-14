This package can render ChatGPT response into Flutter app. This package suppports Markdown and Latex of ChatGPT.

## Features

You can create simple markdown view by this package.

At this moment this package supports:
- List 

        - Unordered list item
        1. Ordered list item

- Horizontal line

        ---

- Links 

        [<text here>](<href>)

- Images with size 

        ![<with>x<hight> someText](url)
- Table

    ```
    | Name | Roll |
    | sohag | 1   |

    ```
    | Name      | Roll |
    |-------------|-------------|
    | sohag      | 1       |

- Bolt text

        **Bolt text**

- Italic text

        *Italic text*

- heading texts 

        # Heading 1
        ## Heading 2
        ### Heading 3
        #### Heading 4
        ##### Heading 5
        ###### Heading 6

- Latex formula \(\frac a b\) or \[\frac ab\]

        \(\frac a b\)

- Radio button and checkbox

        () Unchecked radio
        (x) Checked radio
        [] Unchecked checkbox
        [x] Checked checkbox


## Getting started

Run this command:
```
flutter pub add tex_markdown 
```

## Usage

Check the documentation [here.](https://github.com/saminsohag/flutter_packages/tree/main/gpt_markdown/example)

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

You can find the source code [here.](https://github.com/saminsohag/flutter_packages/tree/main/gpt_markdown)
