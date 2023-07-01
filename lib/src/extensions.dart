import 'dart:typed_data';

extension NumEx on BigInt {
  /// Convert [BigInt] to [int].
  /// Copies bits as is, without truncating value to a signed 64 bit integer.
  /// Allows setting valid unsigned 64 bit value to Dart's [int] to pass into native code expecting uint64 value.
  /// May break on some systems due to endianness or other integer implementation details. Commented part might help.
  int toIntBitwise() {
    var number = this;

    // convert BigInt to byte array (from https://github.com/dart-lang/sdk/issues/32803)
    int bytes = (number.bitLength + 7) >> 3;
    var b256 = BigInt.from(256);
    var result = Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      //result[bytes - 1 - i] = number.remainder(b256).toInt();
      result[i] = number.remainder(b256).toInt();
      number = number >> 8;
    }

    // interpret byte array as int (bits takes as is)
    return result.buffer.asInt64List().single;
  }
}
