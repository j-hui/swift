// RUN: %target-swift-ide-test -print-module -module-to-print=ClassTemplateMemberTypedefSugar -I %S/Inputs -source-filename=x -cxx-interoperability-mode=default | %FileCheck %s

// CHECK:      struct GiveNUMBER<[[SIZE:CUnsignedLong|CUnsignedInt|CUnsignedLongLong]]> {
// CHECK:        typealias NUMBER = [[SIZE]]
// CHECK:        typealias ConstNUMBER = [[SIZE]]
// CHECK:      }

// CHECK:      struct Bad {
// CHECK:        typealias NUMBER = Int
// CHECK:        typealias ConstNUMBER = Int
// CHECK:        static func takeSizeT(_ x: Int) -> Int
// CHECK:        static func takeNUMBER(_ x: Int) -> Int
// CHECK:        static func returnNUMBER() -> Int
// CHECK:        static func takeConstRef(_ x: Int) -> Int
// CHECK:        static func takePtr(_ x: UnsafeMutablePointer<Int>!) -> Int
// CHECK:        static func takeConstNUMBER(_ x: Int) -> Int
// CHECK:        var field: Int
// CHECK:      }
// CHECK:      func takeQualified(_ x: Int) -> Int
// CHECK:      func takeViaDerived(_ x: Int) -> Int
// CHECK:      func takeViaAlias(_ x: Int) -> Int
// CHECK:      struct Mid {
// CHECK:        typealias NUMBER = Int
// CHECK:      struct Deep {
// CHECK:        typealias NUMBER = Int
// CHECK:        static func take(_ x: Int) -> Int
// CHECK:      struct ViaAliasTemplate {
// CHECK:        static func take(_ x: Int) -> Int
// CHECK:      func takeSecond(_ x: Int) -> Int
// CHECK:      struct Unsigned {
// CHECK:        typealias NUMBER = [[SIZE]]
// CHECK:        static func take(_ x: GiveNUMBER<[[SIZE]]>.NUMBER) -> [[SIZE]]
// CHECK:      func takePartial(_ x: PartialGive<UnsafeMutablePointer<[[SIZE]]>>.NUMBER)
// CHECK:      struct Self<[[SIZE]]> {
// CHECK:        typealias NUMBER = [[SIZE]]
// CHECK:        static func take(_ x: Self<[[SIZE]]>.NUMBER) -> [[SIZE]]
