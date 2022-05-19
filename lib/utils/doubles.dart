final noZeroesRegex = RegExp(r'([.]*0)(?!.*\d)');
String trimTrailingZeroes(String number) {
  return number.replaceAll(noZeroesRegex, '');
}
