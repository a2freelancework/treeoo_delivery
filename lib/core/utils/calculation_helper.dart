class CalculationHelper {
  const CalculationHelper._();

  static double stringToDouble(String text, {bool isQty = false}) {
    final fixed = isQty ? 3 : 2;
    final val =
        double.tryParse(text.trim().replaceFirst(RegExp(r'^\D*'), '')) ?? 0;
    return val == val.toInt()
        ? val.toInt().toDouble()
        : double.parse(val.toStringAsFixed(fixed));
  }
}


const kMSymbl = '-';
const kPSymbl = '+';
