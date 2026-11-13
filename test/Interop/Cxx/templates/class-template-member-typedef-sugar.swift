// RUN: %target-run-simple-swift(-cxx-interoperability-mode=default -I %S/Inputs)
//
// REQUIRES: executable_test

import ClassTemplateMemberTypedefSugar
import StdlibUnittest

var TemplateMemberTypedefSugarTestSuite = TestSuite("ClassTemplateMemberTypedefSugar")

TemplateMemberTypedefSugarTestSuite.test("inherited member typedef") {
  let x: Int = 5
  expectEqual(5, Bad.takeNUMBER(x))
  expectEqual(42, Bad.returnNUMBER())
  expectEqual(5, Bad.takeConstRef(x))
  var big = Int.max
  expectEqual(Int.max, Bad.takePtr(&big))
  expectEqual(5, Bad.takeConstNUMBER(x))
  expectEqual(-1, Bad.takeNUMBER(-1))

  var b = Bad()
  expectEqual(7, b.field)
  b.field = 99
  expectEqual(99, b.field)

  expectEqual(5, Deep.take(x))
  expectEqual(5, ViaAliasTemplate.take(x))
}

TemplateMemberTypedefSugarTestSuite.test("qualified member typedef") {
  let x: Int = 5
  expectEqual(5, takeQualified(x))
  expectEqual(5, takeViaDerived(x))
  expectEqual(5, takeViaAlias(x))
  expectEqual(5, takeSecond(x))
}

runAllTests()
