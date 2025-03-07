class Translate {
  late String text;
  late String translatedText;
  late bool isStarred;

  Translate(String text, String translated, bool isStarred) {
    this.text = text;
    translatedText = translated;
    this.isStarred = isStarred;
  }
}
