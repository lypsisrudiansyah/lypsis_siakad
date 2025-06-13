extension CustomStringExtension on String {
  String get plainText {
    String htmlString = this;
    final regex = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(regex, '').trim();
  }
}
