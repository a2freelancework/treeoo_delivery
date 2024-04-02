enum ScrapType {
  scrap(_scrap),
  waste(_waste);

  const ScrapType(this.toText);
  final String toText;
}

const _scrap = 'scrap';
const _waste = 'waste';

extension StringExtType on String {
  ScrapType toScrapType() {
    switch (this) {
      case _scrap:
        return ScrapType.scrap;
      case _waste:
        return ScrapType.waste;
      default:
        throw Exception('Unkmown type');
    }
  }
}
