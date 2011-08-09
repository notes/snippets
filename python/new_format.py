# 完全形
# {name!conv:spec}
# name: 引数を選択する
# conv: 引数を型変換する
# spec: 表示フォーマットを指定する
# 引数0番を repr()でstrに変換して 右詰め40字にformat
print("{0!r:>40s}".format(bytearray(b"hello world")))

# 基本系
# nameを省略すると0から昇順に番号が付く
# convを省略すると何もしない
# specを省略するとstr()を適用してs相当でformat
print("{} {} {}".format("foo", "bar", "baz"))
# nameを指定した場合
print("{0} {1} {2}".format("foo", "bar", "baz"))
# 番号は逆順でも良い
print("{2} {1} {0}".format("foo", "bar", "baz"))
# nameは番号ではなく名前で選択も可能
print("{foo} {bar} {baz}".format(foo="foo", bar="bar", baz="baz"))

# Format指定
# format_spec ::= [[fill]align][sign][#][0][width][,][.precision][type]
# 左寄せ/右寄せ/中央寄せ (align, width)
print("{0:>10}".format("test"))
print("{0:<10}".format("test"))
print("{0:^10}".format("test"))
# 整数format 10進/16進/8進/2進 (type)
print("{0:d}".format(1000))
print("{0:x}".format(1000))
print("{0:o}".format(1000))
print("{0:b}".format(1000))
# 桁指定とpadding (fill, align, width)
print("{0:0>4d}".format(25))
print("{0:X>4d}".format(25))
print("{0:Y>4d}".format(25))
# 数値型のzero-paddingのみの特殊指定 (width)
print("{0:>04d}".format(25))
# 3桁ごとにカンマ挿入 (, type)
print("{0:,d}".format(10000))
# 先頭に0x(16進の場合)などを付ける (#, type)
print("{0:#x}".format(10000))
# 浮動小数点数精度指定 (precision, type)
print("{0:.2f}".format(100.123))

