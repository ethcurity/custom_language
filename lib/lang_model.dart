class LangModel {
  /// the `key` is used to access the value of current language and is the same across multiple language instances
  final String key;

  /// `value` is the actual value that will be returned when we pass the above key and may differ across multiple language instances
  final String value;

  /// `order` is the the order of the appendable values because appendable values may differ among multiple language instances
  /// by default the order uses the default appendable values order
  final List<int> order;

  LangModel(this.key, this.value, {this.order = const []});
}