part of extensions;

extension CurrencyStringX on Object {
  String toPrice({bool withSymbol = false, String unit = '\$'}) {
    if (toString().isNum) {
      return '${withSymbol ? unit : ''}${(this as double).toStringAsFixed(2)}';
    } else {
      return '0.00';
    }
  }
}

extension StringToCurrency on String {
  String formatNumber() {
    List<String> nullList = ['null', ''];
    // , 'NA', 'NaN'];
    // final formatter = new NumberFormat.decimalPattern();
    if (nullList.contains(this)) {
      return '';
    } else {
      var formatter = NumberFormat('##,##,##,##,###.##', 'en_IN');
      return formatter.format(double.parse);
    }
  }

  String formatIndianCurrency(dynamic inputNumber) {
    List<String> nullList = ['null', ''];
    // , 'NA', 'NaN'];
    // final formatter = new NumberFormat.decimalPattern();
    if (nullList.contains(inputNumber)) {
      return '';
    } else if (inputNumber.runtimeType.toString() == 'String') {
      var formatter = NumberFormat('##,##,##,##,###.##', 'en_IN');
      return '\u20B9${formatter.format(double.parse(inputNumber))}';
    } else {
      var formatter = NumberFormat('##,##,##,##,###.##', 'en_IN');
      return '\u20B9${formatter.format(inputNumber)}';
    }
  }

  String toIndianCurrency() {
    String words = "";
    String result = "";
    if (this == "") {
      return '';
    }
    words = IndianCurrencyFromNumber.toWord(this);

    result = words.replaceAll("^\\s+", "").replaceAll("\\b\\s{2,}\\b", " ");
    return result.trim();
  }
}

class IndianCurrencyFromNumber {
  static String toWord(String currency) {
    double number = double.parse(currency);
    // 0 to 999999999.99
    if (number == 0) {
      return "zero";
    }
    // pad with "0"
    String mask = "000000000.00";
    final df = NumberFormat(mask);
    String maskNo = df.format(number);
    // XXnnnnnnn.nn
    int crore = int.parse(maskNo.substring(0, 2));
    // nnXXnnnnn.nn
    int lakh = int.parse(maskNo.substring(2, 4));
    // nnXXnnnnn.nn
    int thousand = int.parse(maskNo.substring(4, 6));
    // nnnnnnXXX.nn
    int hundred = int.parse(maskNo.substring(6, 9));
    // nnnnnn.XX
    int paisa = int.parse(maskNo.substring(10, 12));

    String tradCrore;

    switch (crore) {
      case 0:
        tradCrore = "";
        break;
      case 1:
        tradCrore = "${_convertLessThanOneThousand(crore)} crore ";
        break;
      default:
        tradCrore = "${_convertLessThanOneThousand(crore)} crore ";
    }
    String result = tradCrore;

    String tradLakh;

    switch (lakh) {
      case 0:
        tradLakh = "";
        break;
      case 1:
        tradLakh = "${_convertLessThanOneThousand(lakh)} lakh ";
        break;
      default:
        tradLakh = "${_convertLessThanOneThousand(lakh)} lakh ";
    }
    result = result + tradLakh;

    String tradThousand;
    switch (thousand) {
      case 0:
        tradThousand = "";
        break;
      case 1:
        tradThousand = "${_convertLessThanOneThousand(thousand)} thousand ";
        break;
      default:
        tradThousand = "${_convertLessThanOneThousand(thousand)} thousand ";
    }
    result = result + tradThousand;

    String tradHundred;
    tradHundred = _convertLessThanOneThousand(hundred);
    result = result + tradHundred;

    String tradPaisa;
    switch (paisa) {
      case 0:
        tradPaisa = "";
        break;
      case 1:
        tradPaisa = " and ${_convertLessThanOneThousand(paisa)} paisa ";
        break;
      default:
        tradPaisa = " and ${_convertLessThanOneThousand(paisa)} paisa ";
    }
    result = result + tradPaisa;

    return "$result only";
  }

  static String _convertLessThanOneThousand(int number) {
    List<String> tensNames = [
      "",
      " ten",
      " twenty",
      " thirty",
      " forty",
      " fifty",
      " sixty",
      " seventy",
      " eighty",
      " ninety"
    ];

    List<String> numNames = [
      "",
      " one",
      " two",
      " three",
      " four",
      " five",
      " six",
      " seven",
      " eight",
      " nine",
      " ten",
      " eleven",
      " twelve",
      " thirteen",
      " fourteen",
      " fifteen",
      " sixteen",
      " seventeen",
      " eighteen",
      " nineteen"
    ];
    String soFar;
    if (number % 100 < 20) {
      soFar = numNames[number % 100];
      number = number ~/ 100;
    } else {
      soFar = numNames[number % 10];
      number = number ~/ 10;
      soFar = tensNames[number % 10] + soFar;
      number = number ~/ 10;
    }
    if (number == 0) return soFar;
    return "${numNames[number]} hundred$soFar";
  }
}
