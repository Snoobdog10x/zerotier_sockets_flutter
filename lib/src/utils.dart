import 'dart:convert';
import 'dart:typed_data';

abstract class ZeroTierUtils {
  /// Get the public id part from the identity data (useful if you persist it yourself).
  static String? getIdentityString(Uint8List? identity) {
    if (identity == null) {
      return null;
    }

    return utf8.decode(identity, allowMalformed: true).split(':').first;
  }

  /// Parses uint64 from hex string and puts it's bits into dart's int which is int64.
  static int hexStringToUint64(String hexStr) {
    var result = BigInt.tryParse(hexStr, radix: 16);
    if (result == null) {
      return 0;
    }

    var bytes = writeBigInt(result);
    var ret = bytes.buffer.asInt64List()[0];
    return ret;
  }

  /// https://github.com/dart-lang/sdk/issues/32803
  static Uint8List writeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.
    int bytes = (number.bitLength + 7) >> 3;
    var b256 = BigInt.from(256);
    var result = Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      //result[bytes - 1 - i] = number.remainder(b256).toInt();
      result[i] = number.remainder(b256).toInt();
      number = number >> 8;
    }
    return result;
  }
}
