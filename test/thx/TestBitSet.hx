package thx;

import utest.Assert;
import thx.BitSet;

class TestBitSet {
  public function new() {}

  public function testBitSet() {
    var bits = new BitSet();
    Assert.same(0, bits.length);
    Assert.same('', bits.toString());

    Assert.raises(function() { var bit = bits[0]; });
    Assert.raises(function() { var bit = bits[-1]; });
    Assert.raises(function() { var bit = bits[1]; });
    Assert.raises(function() { var bit = bits[4]; });

    bits[0] = true;
    Assert.same(1, bits.length);
    Assert.same('1', bits.toString());

    bits[1] = true;
    Assert.same(2, bits.length);
    Assert.same('11', bits.toString());

    bits[2] = true;
    Assert.same(3, bits.length);
    Assert.same('111', bits.toString());

    bits[1] = false;
    Assert.same(3, bits.length);
    Assert.same('101', bits.toString());


    bits[32] = true;
    Assert.same(33, bits.length);
    Assert.same('101000000000000000000000000000001', bits.toString());

    for (i in 0...bits.length) {
      if (Arrays.contains([0, 2, 32], i)) {
        Assert.isTrue(bits[i]);
      } else {
        Assert.isFalse(bits[i]);
      }
    }

    Assert.raises(function() { var bit = bits[bits.length + 1]; });

    bits.setAll();
    Assert.same(33, bits.length);
    Assert.same('111111111111111111111111111111111', bits.toString());

    bits.clearAll();
    Assert.same(33, bits.length);
    Assert.same('000000000000000000000000000000000', bits.toString());
  }

  public function testFromBools() {
    var bits = BitSet.fromBools([true, false, true, true]);
    Assert.same(4, bits.length);
    Assert.same(true, bits[0]);
    Assert.same(false, bits[1]);
    Assert.same(true, bits[2]);
    Assert.same(true, bits[3]);
  }

  public function testFromString() {
    var bits = BitSet.fromString('1011');
    Assert.same(4, bits.length);
    Assert.same(true, bits[0]);
    Assert.same(false, bits[1]);
    Assert.same(true, bits[2]);
    Assert.same(true, bits[3]);
  }

  public function testPresetLength() {
    var bits1 = new BitSet(35);
    Assert.same(35, bits1.length);
    for (i in 0...35) {
      Assert.isFalse(bits1[i]);
    }
    Assert.raises(function( ) { var bit = bits1[35]; });

    var bits2 = new BitSet(35).setAll();
    Assert.same(35, bits2.length);
    for (i in 0...35) {
      Assert.isTrue(bits2[i]);
    }
    Assert.raises(function( ) { var bit = bits2[35]; });
  }

  public function testEquals() {
    var b1 = BitSet.fromString('10101100');
    var b2 = BitSet.fromString('10101100');
    var b3 = BitSet.fromString('101011001');
    var b4 = BitSet.fromString('10101101');
    var b5 = BitSet.fromString('1010110');
    Assert.isTrue(b1.equals(b2));
    Assert.isFalse(b1.equals(b3));
    Assert.isFalse(b1.equals(b4));
    Assert.isFalse(b1.equals(b5));
    Assert.isTrue(b1 == b2);
    Assert.isFalse(b1 == b3);
    Assert.isFalse(b1 == b4);
    Assert.isFalse(b1 == b5);
  }

  public function testNotEquals() {
    var b1 = BitSet.fromString('10101100');
    var b2 = BitSet.fromString('10101100');
    var b3 = BitSet.fromString('101011001');
    var b4 = BitSet.fromString('10101101');
    var b5 = BitSet.fromString('1010110');
    Assert.isFalse(b1.notEquals(b2));
    Assert.isTrue(b1.notEquals(b3));
    Assert.isTrue(b1.notEquals(b4));
    Assert.isTrue(b1.notEquals(b5));
    Assert.isFalse(b1 != b2);
    Assert.isTrue(b1 != b3);
    Assert.isTrue(b1 != b4);
    Assert.isTrue(b1 != b5);
  }

  public function testAnd() {
    var b1 = BitSet.fromString('10101100');
    var b2 = BitSet.fromString('11111111');
    var b3 = BitSet.fromString('00000000');
    var b4 = BitSet.fromString('111');
    var b5 = BitSet.fromString('000');
    Assert.isTrue(BitSet.fromString('10101100') == (b1 & b2));
    Assert.isTrue(BitSet.fromString('00000000') == (b1 & b3));
    Assert.raises(function() { b1 & b4; });
    Assert.raises(function() { b1 & b5; });
  }

  public function testOr() {
    var b1 = BitSet.fromString('10101100');
    var b2 = BitSet.fromString('11111111');
    var b3 = BitSet.fromString('00000000');
    var b4 = BitSet.fromString('111');
    var b5 = BitSet.fromString('000');
    Assert.isTrue(BitSet.fromString('11111111') == (b1 | b2));
    Assert.isTrue(BitSet.fromString('10101100') == (b1 | b3));
    Assert.raises(function() { b1 | b4; });
    Assert.raises(function() { b1 | b5; });
  }

  public function testXor() {
    var b1 = BitSet.fromString('10101100');
    var b2 = BitSet.fromString('11111111');
    var b3 = BitSet.fromString('00000000');
    var b4 = BitSet.fromString('111');
    var b5 = BitSet.fromString('000');
    Assert.isTrue(BitSet.fromString('01010011') == (b1 ^ b2));
    Assert.isTrue(BitSet.fromString('10101100') == (b1 ^ b3));
    Assert.raises(function() { b1 ^ b4; });
    Assert.raises(function() { b1 ^ b5; });
  }

  public function testNegate() {
    Assert.isTrue(BitSet.fromString('00000000') == ~BitSet.fromString('11111111'));
    Assert.isTrue(BitSet.fromString('11111111') == ~BitSet.fromString('00000000'));
    Assert.isTrue(BitSet.fromString('01010011') == ~BitSet.fromString('10101100'));
  }

  public function testClone() {
    var a = BitSet.fromString('0101');
    var b = a.clone();
    b.setAt(0, true);
    Assert.same('0101', a.toString());
    Assert.same('1101', b.toString());
  }
}