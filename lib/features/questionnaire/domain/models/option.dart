class Option {
  final String text;

  Option(this.text);

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      json['text'] ?? '', // Default to empty string if 'text' is null
    );
  }
}
