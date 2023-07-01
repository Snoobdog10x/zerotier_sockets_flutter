import 'package:test/test.dart';
import 'package:zerotier_sockets/src/extensions.dart';

void main() {
  test('uint64 which overflows int64 is casted to int64 with same bits', () {
    var a = BigInt.parse("8850338390d0e5ad", radix: 16);
    var b = a.toIntBitwise();

    expect(a.isValidInt, equals(false));
    expect(a.toInt() == b, equals(false));

    var binary1 = _Utils.numToBinaryStr(a, BigInt.zero, BigInt.one, 64);
    var binary2 = _Utils.numToBinaryStr(b, 0, 1, 64);

    expect(binary1, equals(binary2));
  });
}

abstract class _Utils {
  static String numToBinaryStr(dynamic val, dynamic zero, dynamic one, int bits) {
    var temp = val;
    var ret = "";

    for (var i = 0; i < bits; i++) {
      var bit = temp & one;
      ret = "${bit == zero ? '0' : '1'}$ret";
      temp = temp >> 1;
    }

    return ret;
  }
}
