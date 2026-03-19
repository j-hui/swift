// RUN: %target-run-simple-swift(-I %S/Inputs -cxx-interoperability-mode=default -Xfrontend -disable-availability-checking)
// REQUIRES: executable_test

import RefKit
import StdlibUnittest

var RefKitTests = TestSuite("RefKit regression tests")

// Simulate some copy operations that cause retain/releases
@inline(never)
func use<T: Copyable>(_ t: T) -> (T, T) { return (t, t) }

RefKitTests.test("Create a null ref without crashing") {
  let ro = RefObject.createNull()
  expectTrue(ro.isNull())
}

RefKitTests.test("Create reference-counted number object") {
  let n = RefNumberObj.create(42.0)
  let nn = n

  let n1 = n.getPtrUnretained()!
  let n2 = n.getRefUnretained()

  expectEqual(n1.get(), 42.0)

  expectTrue(n2.refCount() >= 4)

  n1.set(-36.5)

  expectEqual(nn.getRefUnretained().get(), -36.5)
}

RefKitTests.test("Create reference-counted boxed float") {
  let f = RefBoxedFloat.create(42.0)
  let ff = f

  let f1 = f.getPtrUnretained()!
  let f2 = f.getRefUnretained()

  expectEqual(f1.pointee, 42.0)

  expectTrue(f2.refCount() >= 4)

  f1.pointee = -36.5

  expectEqual(ff.getRefUnretained().pointee, -36.5)
}

runAllTests()

