// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/impl/fail_extend_partially_defined_interface.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/impl/fail_extend_partially_defined_interface.carbon

interface I {
  class C {
    // CHECK:STDERR: fail_extend_partially_defined_interface.carbon:[[@LINE+6]]:5: error: `extend impl` requires a definition for interface `I`
    // CHECK:STDERR:     extend impl as I;
    // CHECK:STDERR:     ^~~~~~~~~~~~~~~~~
    // CHECK:STDERR: fail_extend_partially_defined_interface.carbon:[[@LINE-5]]:1: note: interface is currently being defined
    // CHECK:STDERR: interface I {
    // CHECK:STDERR: ^~~~~~~~~~~~~
    extend impl as I;
  }
}

// CHECK:STDOUT: --- fail_extend_partially_defined_interface.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: type = interface_type @I [template]
// CHECK:STDOUT:   %Self: %.1 = bind_symbolic_name Self 0 [symbolic]
// CHECK:STDOUT:   %C.1: type = class_type @C [template]
// CHECK:STDOUT:   %C.2: type = class_type @C, @C(%Self) [symbolic]
// CHECK:STDOUT:   %.2: type = struct_type {} [template]
// CHECK:STDOUT:   %.3: <witness> = complete_type_witness %.2 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/operators
// CHECK:STDOUT:     import Core//prelude/types
// CHECK:STDOUT:     import Core//prelude/operators/arithmetic
// CHECK:STDOUT:     import Core//prelude/operators/as
// CHECK:STDOUT:     import Core//prelude/operators/bitwise
// CHECK:STDOUT:     import Core//prelude/operators/comparison
// CHECK:STDOUT:     import Core//prelude/types/bool
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .I = %I.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %I.decl: type = interface_decl @I [template = constants.%.1] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @I {
// CHECK:STDOUT:   %Self: %.1 = bind_symbolic_name Self 0 [symbolic = constants.%Self]
// CHECK:STDOUT:   %C.decl: type = class_decl @C [template = constants.%C.1] {}
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = %Self
// CHECK:STDOUT:   .C = %C.decl
// CHECK:STDOUT:   witness = ()
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: impl @impl: %C.2 as %.1;
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @C(@I.%Self: %.1) {
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     impl_decl @impl {
// CHECK:STDOUT:       %I.ref: type = name_ref I, file.%I.decl [template = constants.%.1]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %.loc20: <witness> = complete_type_witness %.2 [template = constants.%.3]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = constants.%C.2
// CHECK:STDOUT:     has_error
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%Self) {}
// CHECK:STDOUT:
