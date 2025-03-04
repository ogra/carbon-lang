// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/class/raw_self_type.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/class/raw_self_type.carbon

class Class {
  fn F() {
    var r#Self: Self*;
    var p: Self* = r#Self;
  }
}

class MemberNamedSelf {
  class r#Self {}

  fn F(x: Self, y: r#Self);
}

fn MemberNamedSelf.F(x: Self, y: r#Self) {}

// CHECK:STDOUT: --- raw_self_type.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Class: type = class_type @Class [template]
// CHECK:STDOUT:   %F.type.1: type = fn_type @F.1 [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %F.1: %F.type.1 = struct_value () [template]
// CHECK:STDOUT:   %.2: type = struct_type {} [template]
// CHECK:STDOUT:   %.3: <witness> = complete_type_witness %.2 [template]
// CHECK:STDOUT:   %.4: type = ptr_type %Class [template]
// CHECK:STDOUT:   %.5: type = ptr_type %.2 [template]
// CHECK:STDOUT:   %MemberNamedSelf: type = class_type @MemberNamedSelf [template]
// CHECK:STDOUT:   %Self: type = class_type @Self [template]
// CHECK:STDOUT:   %F.type.2: type = fn_type @F.2 [template]
// CHECK:STDOUT:   %F.2: %F.type.2 = struct_value () [template]
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
// CHECK:STDOUT:     .Class = %Class.decl
// CHECK:STDOUT:     .MemberNamedSelf = %MemberNamedSelf.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %Class.decl: type = class_decl @Class [template = constants.%Class] {}
// CHECK:STDOUT:   %MemberNamedSelf.decl: type = class_decl @MemberNamedSelf [template = constants.%MemberNamedSelf] {}
// CHECK:STDOUT:   %F.decl: %F.type.2 = fn_decl @F.2 [template = constants.%F.2] {
// CHECK:STDOUT:     %Self.ref.loc24_25: type = name_ref Self, constants.%MemberNamedSelf [template = constants.%MemberNamedSelf]
// CHECK:STDOUT:     %x.loc24_22.1: %MemberNamedSelf = param x, runtime_param0
// CHECK:STDOUT:     @F.2.%x: %MemberNamedSelf = bind_name x, %x.loc24_22.1
// CHECK:STDOUT:     %Self.ref.loc24_34: type = name_ref r#Self, @MemberNamedSelf.%Self.decl [template = constants.%Self]
// CHECK:STDOUT:     %y.loc24_31.1: %Self = param y, runtime_param1
// CHECK:STDOUT:     @F.2.%y: %Self = bind_name y, %y.loc24_31.1
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @Class {
// CHECK:STDOUT:   %F.decl: %F.type.1 = fn_decl @F.1 [template = constants.%F.1] {}
// CHECK:STDOUT:   %.loc16: <witness> = complete_type_witness %.2 [template = constants.%.3]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%Class
// CHECK:STDOUT:   .F = %F.decl
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @MemberNamedSelf {
// CHECK:STDOUT:   %Self.decl: type = class_decl @Self [template = constants.%Self] {}
// CHECK:STDOUT:   %F.decl: %F.type.2 = fn_decl @F.2 [template = constants.%F.2] {
// CHECK:STDOUT:     %Self.ref.loc21_11: type = name_ref Self, constants.%MemberNamedSelf [template = constants.%MemberNamedSelf]
// CHECK:STDOUT:     %x.loc21_8.1: %MemberNamedSelf = param x, runtime_param0
// CHECK:STDOUT:     %x.loc21_8.2: %MemberNamedSelf = bind_name x, %x.loc21_8.1
// CHECK:STDOUT:     %Self.ref.loc21_20: type = name_ref r#Self, %Self.decl [template = constants.%Self]
// CHECK:STDOUT:     %y.loc21_17.1: %Self = param y, runtime_param1
// CHECK:STDOUT:     %y.loc21_17.2: %Self = bind_name y, %y.loc21_17.1
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %.loc22: <witness> = complete_type_witness %.2 [template = constants.%.3]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%MemberNamedSelf
// CHECK:STDOUT:   .r#Self = %Self.decl
// CHECK:STDOUT:   .F = %F.decl
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @Self {
// CHECK:STDOUT:   %.loc19: <witness> = complete_type_witness %.2 [template = constants.%.3]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%Self
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F.1() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Self.ref.loc13: type = name_ref Self, constants.%Class [template = constants.%Class]
// CHECK:STDOUT:   %.loc13: type = ptr_type %Class [template = constants.%.4]
// CHECK:STDOUT:   %Self.var: ref %.4 = var r#Self
// CHECK:STDOUT:   %Self: ref %.4 = bind_name r#Self, %Self.var
// CHECK:STDOUT:   %Self.ref.loc14_12: type = name_ref Self, constants.%Class [template = constants.%Class]
// CHECK:STDOUT:   %.loc14_16: type = ptr_type %Class [template = constants.%.4]
// CHECK:STDOUT:   %p.var: ref %.4 = var p
// CHECK:STDOUT:   %p: ref %.4 = bind_name p, %p.var
// CHECK:STDOUT:   %Self.ref.loc14_20: ref %.4 = name_ref r#Self, %Self
// CHECK:STDOUT:   %.loc14_20: %.4 = bind_value %Self.ref.loc14_20
// CHECK:STDOUT:   assign %p.var, %.loc14_20
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F.2(%x: %MemberNamedSelf, %y: %Self) {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
