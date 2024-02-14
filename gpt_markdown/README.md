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
flutter pub add gpt_markdown 
```

## Usage

Check the documentation [here.](https://github.com/saminsohag/flutter_packages/tree/main/gpt_markdown/example)

```dart
import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

return TexMarkdown(
    '''
    * This is a unordered list.
    ''',
    style: const TextStyle(
    color: Colors.red,
),

```

## Here I am providing some sample response of ChatGPT and it's Response:


```markdown
## ChatGPT Response

Welcome to ChatGPT! Below is an example of a response with Markdown and LaTeX code:

### Markdown Example

You can use Markdown to format text easily. Here are some examples:

- **Bold Text**: **This text is bold**
- *Italic Text*: *This text is italicized*
- [Link](https://www.example.com): [This is a link](https://www.example.com)
- Lists:
  1. Item 1
  2. Item 2
  3. Item 3

### LaTeX Example

You can also use LaTeX for mathematical expressions. Here's an example:

- **Equation**: \( f(x) = x^2 + 2x + 1 \)
- **Integral**: \( \int_{0}^{1} x^2 \, dx \)
- **Matrix**:

\[
\begin{bmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{bmatrix}
\]

### Conclusion

Markdown and LaTeX can be powerful tools for formatting text and mathematical expressions in your Flutter app. If you have any questions or need further assistance, feel free to ask!
```


## Additional information

You can find the source code [here.](https://github.com/saminsohag/flutter_packages/tree/main/gpt_markdown)
