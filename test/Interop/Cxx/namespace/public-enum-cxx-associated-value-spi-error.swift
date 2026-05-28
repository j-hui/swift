// RUN: rm -rf %t
// RUN: split-file %s %t
// RUN: %target-swift-frontend -emit-module -o %t/Inputs/SwiftLib.swiftmodule -I %t/Inputs %t/Inputs/SwiftLib.swift -cxx-interoperability-mode=default -module-name SwiftLib
// RUN: %target-swift-frontend -typecheck -verify -suppress-notes -I %t/Inputs %t/test.swift -cxx-interoperability-mode=default

//--- Inputs/module.modulemap
module CxxLib {
  header "cxx-lib.h"
  requires cplusplus
}

//--- Inputs/cxx-lib.h
namespace ns { enum E { X }; }

//--- Inputs/SwiftLib.swift
import CxxLib
public enum S { case c(ns.E) }

//--- test.swift
import CxxLib
import SwiftLib
func f() {
  _ = S.c(ns.X) // expected-error {{'S' is inaccessible due to '@_spi' protection level}}
}
