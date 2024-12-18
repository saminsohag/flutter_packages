part of 'gpt_markdown.dart';

/// Theme defined for `TexMarkdown` widget
class GptMarkdownThemeData extends ThemeExtension<GptMarkdownThemeData> {
  GptMarkdownThemeData({
    required this.highlightColor,
  });

  /// Define default attributes.
  factory GptMarkdownThemeData.from(BuildContext context) {
    return GptMarkdownThemeData(
      highlightColor:
          Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(50),
    );
  }

  Color highlightColor;

  @override
  GptMarkdownThemeData copyWith({Color? highlightColor}) {
    return GptMarkdownThemeData(
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  GptMarkdownThemeData lerp(GptMarkdownThemeData? other, double t) {
    if (other == null) {
      return this;
    }
    return GptMarkdownThemeData(
      highlightColor:
          Color.lerp(highlightColor, other.highlightColor, t) ?? highlightColor,
    );
  }
}

/// Wrap a `Widget` with `GptMarkdownTheme` to provide `GptMarkdownThemeData` in your intiar app.
class GptMarkdownTheme extends InheritedWidget {
  const GptMarkdownTheme({
    super.key,
    required this.gptThemeData,
    required super.child,
  });
  final GptMarkdownThemeData gptThemeData;

  static GptMarkdownThemeData of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<GptMarkdownTheme>();
    if (provider != null) {
      return provider.gptThemeData;
    }
    final themeData = Theme.of(context).extension<GptMarkdownThemeData>();
    if (themeData != null) {
      return themeData;
    }
    return GptMarkdownThemeData.from(context);
  }

  @override
  bool updateShouldNotify(GptMarkdownTheme oldWidget) {
    return gptThemeData != oldWidget.gptThemeData;
  }
}
