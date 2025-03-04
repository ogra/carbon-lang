// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/builtins/float/greater.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/builtins/float/greater.carbon

// --- float_greater.carbon

fn Greater(a: f64, b: f64) -> bool = "float.greater";
fn Negate(a: f64) -> f64 = "float.negate";

class True {}
class False {}

fn F(true_: True, false_: False) {
  false_ as (if Greater(1.0, 2.0) then True else False);
  false_ as (if Greater(1.0, 1.0) then True else False);
  true_ as (if Greater(1.0, 0.0) then True else False);
  false_ as (if Greater(Negate(1.0), 0.0) then True else False);
  true_ as (if Greater(0.0, Negate(1.0)) then True else False);
}

fn RuntimeCall(a: f64, b: f64) -> bool {
  return Greater(a, b);
}

// CHECK:STDOUT: --- float_greater.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: i32 = int_literal 64 [template]
// CHECK:STDOUT:   %Float.type: type = fn_type @Float [template]
// CHECK:STDOUT:   %.2: type = tuple_type () [template]
// CHECK:STDOUT:   %Float: %Float.type = struct_value () [template]
// CHECK:STDOUT:   %Bool.type: type = fn_type @Bool [template]
// CHECK:STDOUT:   %Bool: %Bool.type = struct_value () [template]
// CHECK:STDOUT:   %Greater.type: type = fn_type @Greater [template]
// CHECK:STDOUT:   %Greater: %Greater.type = struct_value () [template]
// CHECK:STDOUT:   %Negate.type: type = fn_type @Negate [template]
// CHECK:STDOUT:   %Negate: %Negate.type = struct_value () [template]
// CHECK:STDOUT:   %True: type = class_type @True [template]
// CHECK:STDOUT:   %.3: type = struct_type {} [template]
// CHECK:STDOUT:   %.4: <witness> = complete_type_witness %.3 [template]
// CHECK:STDOUT:   %False: type = class_type @False [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT:   %.5: type = ptr_type %.3 [template]
// CHECK:STDOUT:   %.6: f64 = float_literal 1 [template]
// CHECK:STDOUT:   %.7: f64 = float_literal 2 [template]
// CHECK:STDOUT:   %.8: bool = bool_literal false [template]
// CHECK:STDOUT:   %.9: f64 = float_literal 0 [template]
// CHECK:STDOUT:   %.10: bool = bool_literal true [template]
// CHECK:STDOUT:   %.11: f64 = float_literal -1 [template]
// CHECK:STDOUT:   %RuntimeCall.type: type = fn_type @RuntimeCall [template]
// CHECK:STDOUT:   %RuntimeCall: %RuntimeCall.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Float = %import_ref.1
// CHECK:STDOUT:     .Bool = %import_ref.2
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/operators
// CHECK:STDOUT:     import Core//prelude/types
// CHECK:STDOUT:     import Core//prelude/operators/arithmetic
// CHECK:STDOUT:     import Core//prelude/operators/as
// CHECK:STDOUT:     import Core//prelude/operators/bitwise
// CHECK:STDOUT:     import Core//prelude/operators/comparison
// CHECK:STDOUT:     import Core//prelude/types/bool
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref.1: %Float.type = import_ref Core//prelude/types, inst+32, loaded [template = constants.%Float]
// CHECK:STDOUT:   %import_ref.2: %Bool.type = import_ref Core//prelude/types/bool, inst+2, loaded [template = constants.%Bool]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .Greater = %Greater.decl
// CHECK:STDOUT:     .Negate = %Negate.decl
// CHECK:STDOUT:     .True = %True.decl
// CHECK:STDOUT:     .False = %False.decl
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:     .RuntimeCall = %RuntimeCall.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %Greater.decl: %Greater.type = fn_decl @Greater [template = constants.%Greater] {
// CHECK:STDOUT:     %.loc2_15.1: i32 = int_literal 64 [template = constants.%.1]
// CHECK:STDOUT:     %float.make_type.loc2_15: init type = call constants.%Float(%.loc2_15.1) [template = f64]
// CHECK:STDOUT:     %.loc2_15.2: type = value_of_initializer %float.make_type.loc2_15 [template = f64]
// CHECK:STDOUT:     %.loc2_15.3: type = converted %float.make_type.loc2_15, %.loc2_15.2 [template = f64]
// CHECK:STDOUT:     %a.loc2_12.1: f64 = param a, runtime_param0
// CHECK:STDOUT:     @Greater.%a: f64 = bind_name a, %a.loc2_12.1
// CHECK:STDOUT:     %.loc2_23.1: i32 = int_literal 64 [template = constants.%.1]
// CHECK:STDOUT:     %float.make_type.loc2_23: init type = call constants.%Float(%.loc2_23.1) [template = f64]
// CHECK:STDOUT:     %.loc2_23.2: type = value_of_initializer %float.make_type.loc2_23 [template = f64]
// CHECK:STDOUT:     %.loc2_23.3: type = converted %float.make_type.loc2_23, %.loc2_23.2 [template = f64]
// CHECK:STDOUT:     %b.loc2_20.1: f64 = param b, runtime_param1
// CHECK:STDOUT:     @Greater.%b: f64 = bind_name b, %b.loc2_20.1
// CHECK:STDOUT:     %bool.make_type.loc2: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc2_31.1: type = value_of_initializer %bool.make_type.loc2 [template = bool]
// CHECK:STDOUT:     %.loc2_31.2: type = converted %bool.make_type.loc2, %.loc2_31.1 [template = bool]
// CHECK:STDOUT:     @Greater.%return: ref bool = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Negate.decl: %Negate.type = fn_decl @Negate [template = constants.%Negate] {
// CHECK:STDOUT:     %.loc3_14.1: i32 = int_literal 64 [template = constants.%.1]
// CHECK:STDOUT:     %float.make_type.loc3_14: init type = call constants.%Float(%.loc3_14.1) [template = f64]
// CHECK:STDOUT:     %.loc3_14.2: type = value_of_initializer %float.make_type.loc3_14 [template = f64]
// CHECK:STDOUT:     %.loc3_14.3: type = converted %float.make_type.loc3_14, %.loc3_14.2 [template = f64]
// CHECK:STDOUT:     %a.loc3_11.1: f64 = param a, runtime_param0
// CHECK:STDOUT:     @Negate.%a: f64 = bind_name a, %a.loc3_11.1
// CHECK:STDOUT:     %.loc3_22.1: i32 = int_literal 64 [template = constants.%.1]
// CHECK:STDOUT:     %float.make_type.loc3_22: init type = call constants.%Float(%.loc3_22.1) [template = f64]
// CHECK:STDOUT:     %.loc3_22.2: type = value_of_initializer %float.make_type.loc3_22 [template = f64]
// CHECK:STDOUT:     %.loc3_22.3: type = converted %float.make_type.loc3_22, %.loc3_22.2 [template = f64]
// CHECK:STDOUT:     @Negate.%return: ref f64 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %True.decl: type = class_decl @True [template = constants.%True] {}
// CHECK:STDOUT:   %False.decl: type = class_decl @False [template = constants.%False] {}
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {
// CHECK:STDOUT:     %True.ref: type = name_ref True, %True.decl [template = constants.%True]
// CHECK:STDOUT:     %true_.loc8_6.1: %True = param true_, runtime_param0
// CHECK:STDOUT:     @F.%true_: %True = bind_name true_, %true_.loc8_6.1
// CHECK:STDOUT:     %False.ref: type = name_ref False, %False.decl [template = constants.%False]
// CHECK:STDOUT:     %false_.loc8_19.1: %False = param false_, runtime_param1
// CHECK:STDOUT:     @F.%false_: %False = bind_name false_, %false_.loc8_19.1
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %RuntimeCall.decl: %RuntimeCall.type = fn_decl @RuntimeCall [template = constants.%RuntimeCall] {
// CHECK:STDOUT:     %.loc16_19.1: i32 = int_literal 64 [template = constants.%.1]
// CHECK:STDOUT:     %float.make_type.loc16_19: init type = call constants.%Float(%.loc16_19.1) [template = f64]
// CHECK:STDOUT:     %.loc16_19.2: type = value_of_initializer %float.make_type.loc16_19 [template = f64]
// CHECK:STDOUT:     %.loc16_19.3: type = converted %float.make_type.loc16_19, %.loc16_19.2 [template = f64]
// CHECK:STDOUT:     %a.loc16_16.1: f64 = param a, runtime_param0
// CHECK:STDOUT:     @RuntimeCall.%a: f64 = bind_name a, %a.loc16_16.1
// CHECK:STDOUT:     %.loc16_27.1: i32 = int_literal 64 [template = constants.%.1]
// CHECK:STDOUT:     %float.make_type.loc16_27: init type = call constants.%Float(%.loc16_27.1) [template = f64]
// CHECK:STDOUT:     %.loc16_27.2: type = value_of_initializer %float.make_type.loc16_27 [template = f64]
// CHECK:STDOUT:     %.loc16_27.3: type = converted %float.make_type.loc16_27, %.loc16_27.2 [template = f64]
// CHECK:STDOUT:     %b.loc16_24.1: f64 = param b, runtime_param1
// CHECK:STDOUT:     @RuntimeCall.%b: f64 = bind_name b, %b.loc16_24.1
// CHECK:STDOUT:     %bool.make_type.loc16: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc16_35.1: type = value_of_initializer %bool.make_type.loc16 [template = bool]
// CHECK:STDOUT:     %.loc16_35.2: type = converted %bool.make_type.loc16, %.loc16_35.1 [template = bool]
// CHECK:STDOUT:     @RuntimeCall.%return: ref bool = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @True {
// CHECK:STDOUT:   %.loc5: <witness> = complete_type_witness %.3 [template = constants.%.4]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%True
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @False {
// CHECK:STDOUT:   %.loc6: <witness> = complete_type_witness %.3 [template = constants.%.4]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%False
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Float(%size: i32) -> type = "float.make_type";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Bool() -> type = "bool.make_type";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Greater(%a: f64, %b: f64) -> bool = "float.greater";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Negate(%a: f64) -> f64 = "float.negate";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F(%true_: %True, %false_: %False) {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %false_.ref.loc9: %False = name_ref false_, %false_
// CHECK:STDOUT:   %Greater.ref.loc9: %Greater.type = name_ref Greater, file.%Greater.decl [template = constants.%Greater]
// CHECK:STDOUT:   %.loc9_25: f64 = float_literal 1 [template = constants.%.6]
// CHECK:STDOUT:   %.loc9_30: f64 = float_literal 2 [template = constants.%.7]
// CHECK:STDOUT:   %float.greater.loc9: init bool = call %Greater.ref.loc9(%.loc9_25, %.loc9_30) [template = constants.%.8]
// CHECK:STDOUT:   %.loc9_14.1: bool = value_of_initializer %float.greater.loc9 [template = constants.%.8]
// CHECK:STDOUT:   %.loc9_14.2: bool = converted %float.greater.loc9, %.loc9_14.1 [template = constants.%.8]
// CHECK:STDOUT:   if %.loc9_14.2 br !if.expr.then.loc9 else br !if.expr.else.loc9
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.then.loc9:
// CHECK:STDOUT:   %True.ref.loc9: type = name_ref True, file.%True.decl [template = constants.%True]
// CHECK:STDOUT:   br !if.expr.result.loc9(%True.ref.loc9)
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.else.loc9:
// CHECK:STDOUT:   %False.ref.loc9: type = name_ref False, file.%False.decl [template = constants.%False]
// CHECK:STDOUT:   br !if.expr.result.loc9(%False.ref.loc9)
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.result.loc9:
// CHECK:STDOUT:   %.loc9_14.3: type = block_arg !if.expr.result.loc9 [template = constants.%False]
// CHECK:STDOUT:   %false_.ref.loc10: %False = name_ref false_, %false_
// CHECK:STDOUT:   %Greater.ref.loc10: %Greater.type = name_ref Greater, file.%Greater.decl [template = constants.%Greater]
// CHECK:STDOUT:   %.loc10_25: f64 = float_literal 1 [template = constants.%.6]
// CHECK:STDOUT:   %.loc10_30: f64 = float_literal 1 [template = constants.%.6]
// CHECK:STDOUT:   %float.greater.loc10: init bool = call %Greater.ref.loc10(%.loc10_25, %.loc10_30) [template = constants.%.8]
// CHECK:STDOUT:   %.loc10_14.1: bool = value_of_initializer %float.greater.loc10 [template = constants.%.8]
// CHECK:STDOUT:   %.loc10_14.2: bool = converted %float.greater.loc10, %.loc10_14.1 [template = constants.%.8]
// CHECK:STDOUT:   if %.loc10_14.2 br !if.expr.then.loc10 else br !if.expr.else.loc10
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.then.loc10:
// CHECK:STDOUT:   %True.ref.loc10: type = name_ref True, file.%True.decl [template = constants.%True]
// CHECK:STDOUT:   br !if.expr.result.loc10(%True.ref.loc10)
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.else.loc10:
// CHECK:STDOUT:   %False.ref.loc10: type = name_ref False, file.%False.decl [template = constants.%False]
// CHECK:STDOUT:   br !if.expr.result.loc10(%False.ref.loc10)
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.result.loc10:
// CHECK:STDOUT:   %.loc10_14.3: type = block_arg !if.expr.result.loc10 [template = constants.%False]
// CHECK:STDOUT:   %true_.ref.loc11: %True = name_ref true_, %true_
// CHECK:STDOUT:   %Greater.ref.loc11: %Greater.type = name_ref Greater, file.%Greater.decl [template = constants.%Greater]
// CHECK:STDOUT:   %.loc11_24: f64 = float_literal 1 [template = constants.%.6]
// CHECK:STDOUT:   %.loc11_29: f64 = float_literal 0 [template = constants.%.9]
// CHECK:STDOUT:   %float.greater.loc11: init bool = call %Greater.ref.loc11(%.loc11_24, %.loc11_29) [template = constants.%.10]
// CHECK:STDOUT:   %.loc11_13.1: bool = value_of_initializer %float.greater.loc11 [template = constants.%.10]
// CHECK:STDOUT:   %.loc11_13.2: bool = converted %float.greater.loc11, %.loc11_13.1 [template = constants.%.10]
// CHECK:STDOUT:   if %.loc11_13.2 br !if.expr.then.loc11 else br !if.expr.else.loc11
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.then.loc11:
// CHECK:STDOUT:   %True.ref.loc11: type = name_ref True, file.%True.decl [template = constants.%True]
// CHECK:STDOUT:   br !if.expr.result.loc11(%True.ref.loc11)
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.else.loc11:
// CHECK:STDOUT:   %False.ref.loc11: type = name_ref False, file.%False.decl [template = constants.%False]
// CHECK:STDOUT:   br !if.expr.result.loc11(%False.ref.loc11)
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.result.loc11:
// CHECK:STDOUT:   %.loc11_13.3: type = block_arg !if.expr.result.loc11 [template = constants.%True]
// CHECK:STDOUT:   %false_.ref.loc12: %False = name_ref false_, %false_
// CHECK:STDOUT:   %Greater.ref.loc12: %Greater.type = name_ref Greater, file.%Greater.decl [template = constants.%Greater]
// CHECK:STDOUT:   %Negate.ref.loc12: %Negate.type = name_ref Negate, file.%Negate.decl [template = constants.%Negate]
// CHECK:STDOUT:   %.loc12_32: f64 = float_literal 1 [template = constants.%.6]
// CHECK:STDOUT:   %float.negate.loc12: init f64 = call %Negate.ref.loc12(%.loc12_32) [template = constants.%.11]
// CHECK:STDOUT:   %.loc12_38: f64 = float_literal 0 [template = constants.%.9]
// CHECK:STDOUT:   %.loc12_24.1: f64 = value_of_initializer %float.negate.loc12 [template = constants.%.11]
// CHECK:STDOUT:   %.loc12_24.2: f64 = converted %float.negate.loc12, %.loc12_24.1 [template = constants.%.11]
// CHECK:STDOUT:   %float.greater.loc12: init bool = call %Greater.ref.loc12(%.loc12_24.2, %.loc12_38) [template = constants.%.8]
// CHECK:STDOUT:   %.loc12_14.1: bool = value_of_initializer %float.greater.loc12 [template = constants.%.8]
// CHECK:STDOUT:   %.loc12_14.2: bool = converted %float.greater.loc12, %.loc12_14.1 [template = constants.%.8]
// CHECK:STDOUT:   if %.loc12_14.2 br !if.expr.then.loc12 else br !if.expr.else.loc12
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.then.loc12:
// CHECK:STDOUT:   %True.ref.loc12: type = name_ref True, file.%True.decl [template = constants.%True]
// CHECK:STDOUT:   br !if.expr.result.loc12(%True.ref.loc12)
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.else.loc12:
// CHECK:STDOUT:   %False.ref.loc12: type = name_ref False, file.%False.decl [template = constants.%False]
// CHECK:STDOUT:   br !if.expr.result.loc12(%False.ref.loc12)
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.result.loc12:
// CHECK:STDOUT:   %.loc12_14.3: type = block_arg !if.expr.result.loc12 [template = constants.%False]
// CHECK:STDOUT:   %true_.ref.loc13: %True = name_ref true_, %true_
// CHECK:STDOUT:   %Greater.ref.loc13: %Greater.type = name_ref Greater, file.%Greater.decl [template = constants.%Greater]
// CHECK:STDOUT:   %.loc13_24: f64 = float_literal 0 [template = constants.%.9]
// CHECK:STDOUT:   %Negate.ref.loc13: %Negate.type = name_ref Negate, file.%Negate.decl [template = constants.%Negate]
// CHECK:STDOUT:   %.loc13_36: f64 = float_literal 1 [template = constants.%.6]
// CHECK:STDOUT:   %float.negate.loc13: init f64 = call %Negate.ref.loc13(%.loc13_36) [template = constants.%.11]
// CHECK:STDOUT:   %.loc13_23.1: f64 = value_of_initializer %float.negate.loc13 [template = constants.%.11]
// CHECK:STDOUT:   %.loc13_23.2: f64 = converted %float.negate.loc13, %.loc13_23.1 [template = constants.%.11]
// CHECK:STDOUT:   %float.greater.loc13: init bool = call %Greater.ref.loc13(%.loc13_24, %.loc13_23.2) [template = constants.%.10]
// CHECK:STDOUT:   %.loc13_13.1: bool = value_of_initializer %float.greater.loc13 [template = constants.%.10]
// CHECK:STDOUT:   %.loc13_13.2: bool = converted %float.greater.loc13, %.loc13_13.1 [template = constants.%.10]
// CHECK:STDOUT:   if %.loc13_13.2 br !if.expr.then.loc13 else br !if.expr.else.loc13
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.then.loc13:
// CHECK:STDOUT:   %True.ref.loc13: type = name_ref True, file.%True.decl [template = constants.%True]
// CHECK:STDOUT:   br !if.expr.result.loc13(%True.ref.loc13)
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.else.loc13:
// CHECK:STDOUT:   %False.ref.loc13: type = name_ref False, file.%False.decl [template = constants.%False]
// CHECK:STDOUT:   br !if.expr.result.loc13(%False.ref.loc13)
// CHECK:STDOUT:
// CHECK:STDOUT: !if.expr.result.loc13:
// CHECK:STDOUT:   %.loc13_13.3: type = block_arg !if.expr.result.loc13 [template = constants.%True]
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @RuntimeCall(%a: f64, %b: f64) -> bool {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Greater.ref: %Greater.type = name_ref Greater, file.%Greater.decl [template = constants.%Greater]
// CHECK:STDOUT:   %a.ref: f64 = name_ref a, %a
// CHECK:STDOUT:   %b.ref: f64 = name_ref b, %b
// CHECK:STDOUT:   %float.greater: init bool = call %Greater.ref(%a.ref, %b.ref)
// CHECK:STDOUT:   %.loc17_23.1: bool = value_of_initializer %float.greater
// CHECK:STDOUT:   %.loc17_23.2: bool = converted %float.greater, %.loc17_23.1
// CHECK:STDOUT:   return %.loc17_23.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
