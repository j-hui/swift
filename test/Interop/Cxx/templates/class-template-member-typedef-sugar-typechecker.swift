// RUN: %target-typecheck-verify-swift -cxx-interoperability-mode=default -I %S/Inputs

import ClassTemplateMemberTypedefSugar

func go(_ i: Int, _ u: UInt) {
  let x: Int = 5
  _ = Good.takeNUMBER(x)
  _ = Bad.takeSizeT(x)
  _ = Bad.takeNUMBER(x)
  _ = Bad.takeNUMBER(i)
  _ = Bad.takeNUMBER(u) // expected-error {{cannot convert value of type 'UInt' to expected argument type 'Int'}}
  let _: Int = Bad.returnNUMBER()
  _ = Bad.takeConstRef(x)
  var y = x
  _ = Bad.takePtr(&y)
  _ = Bad.takeConstNUMBER(x)

  var b = Bad()
  let _: Int = b.field
  b.field = x

  let _: Bad.NUMBER = i
  let _: Bad.ConstNUMBER = i
  let _: Deep.NUMBER = i

  _ = takeQualified(x)
  _ = takeViaDerived(x)
  _ = takeViaAlias(x)
  _ = Deep.take(x)
  _ = ViaAliasTemplate.take(x)
  _ = takeSecond(x)

  // The specialization itself is shared by every spelling of its arguments,
  // so its own members are imported in terms of the canonical type.
  let _: GiveSizeT.NUMBER = u
  _ = SelfSizeT.take(u)
  _ = Unsigned.take(u)
  _ = Unsigned.take(i) // expected-error {{cannot convert value of type 'Int' to expected argument type}}
}
