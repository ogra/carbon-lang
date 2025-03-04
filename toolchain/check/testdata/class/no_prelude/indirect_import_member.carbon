// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/class/no_prelude/indirect_import_member.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/class/no_prelude/indirect_import_member.carbon

// ============================================================================
// Setup files
// ============================================================================

// --- a.carbon

library "[[@TEST_NAME]]";

class C {
  fn F() {}
}

// --- b.carbon

library "[[@TEST_NAME]]";

export import library "a";

// --- c.carbon

library "[[@TEST_NAME]]";

import library "b";

export C;

// --- d.carbon

library "[[@TEST_NAME]]";

export import library "c";

// --- e.carbon

library "[[@TEST_NAME]]";

import library "c";

class D {
  alias C = C;
}

// --- f.carbon

library "[[@TEST_NAME]]";

export import library "e";

// ============================================================================
// Test files
// ============================================================================

// --- use_b.carbon

library "[[@TEST_NAME]]";

import library "b";

var x: () = C.F();

// --- use_c.carbon

library "[[@TEST_NAME]]";

import library "c";

var x: () = C.F();

// --- use_d.carbon

library "[[@TEST_NAME]]";

import library "d";

var x: () = C.F();

// --- use_e.carbon

library "[[@TEST_NAME]]";

import library "e";

var x: () = D.C.F();

// --- use_f.carbon

library "[[@TEST_NAME]]";

import library "f";

var x: () = D.C.F();

// CHECK:STDOUT: --- a.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT:   %.2: type = struct_type {} [template]
// CHECK:STDOUT:   %.3: <witness> = complete_type_witness %.2 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %C.decl: type = class_decl @C [template = constants.%C] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {}
// CHECK:STDOUT:   %.loc6: <witness> = complete_type_witness %.2 [template = constants.%.3]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%C
// CHECK:STDOUT:   .F = %F.decl
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- b.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref = import_ref Main//a, inst+1, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C = imports.%import_ref
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- c.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %.1: type = struct_type {} [template]
// CHECK:STDOUT:   %.2: <witness> = complete_type_witness %.1 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Main//a, inst+1, loaded [template = constants.%C]
// CHECK:STDOUT:   %import_ref.2 = import_ref Main//a, inst+2, unloaded
// CHECK:STDOUT:   %import_ref.3 = import_ref Main//a, inst+3, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C = %C
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %C: type = export C, imports.%import_ref.1 [template = constants.%C]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.2
// CHECK:STDOUT:   .F = imports.%import_ref.3
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- d.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref = import_ref Main//c, inst+9, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C = imports.%import_ref
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- e.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %D: type = class_type @D [template]
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %.1: type = struct_type {} [template]
// CHECK:STDOUT:   %.2: <witness> = complete_type_witness %.1 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Main//c, inst+9, loaded [template = constants.%C]
// CHECK:STDOUT:   %import_ref.2 = import_ref Main//c, inst+7, unloaded
// CHECK:STDOUT:   %import_ref.3 = import_ref Main//c, inst+8, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C = imports.%import_ref.1
// CHECK:STDOUT:     .D = %D.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %D.decl: type = class_decl @D [template = constants.%D] {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @D {
// CHECK:STDOUT:   %C.ref: type = name_ref C, imports.%import_ref.1 [template = constants.%C]
// CHECK:STDOUT:   %C: type = bind_alias C, imports.%import_ref.1 [template = constants.%C]
// CHECK:STDOUT:   %.loc8: <witness> = complete_type_witness %.1 [template = constants.%.2]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%D
// CHECK:STDOUT:   .C = %C
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.2
// CHECK:STDOUT:   .F = imports.%import_ref.3
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- f.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref = import_ref Main//e, inst+3, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .D = imports.%import_ref
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- use_b.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %.2: type = struct_type {} [template]
// CHECK:STDOUT:   %.3: <witness> = complete_type_witness %.2 [template]
// CHECK:STDOUT:   %.4: type = ptr_type %.2 [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Main//a, inst+1, loaded [template = constants.%C]
// CHECK:STDOUT:   %import_ref.2 = import_ref Main//a, inst+2, unloaded
// CHECK:STDOUT:   %import_ref.3: %F.type = import_ref Main//a, inst+3, loaded [template = constants.%F]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C = imports.%import_ref.1
// CHECK:STDOUT:     .x = %x
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %.loc6_9.1: %.1 = tuple_literal ()
// CHECK:STDOUT:   %.loc6_9.2: type = converted %.loc6_9.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:   %x.var: ref %.1 = var x
// CHECK:STDOUT:   %x: ref %.1 = bind_name x, %x.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.2
// CHECK:STDOUT:   .F = imports.%import_ref.3
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %C.ref: type = name_ref C, imports.%import_ref.1 [template = constants.%C]
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.3 [template = constants.%F]
// CHECK:STDOUT:   %F.call: init %.1 = call %F.ref()
// CHECK:STDOUT:   assign file.%x.var, %F.call
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- use_c.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %.2: type = struct_type {} [template]
// CHECK:STDOUT:   %.3: <witness> = complete_type_witness %.2 [template]
// CHECK:STDOUT:   %.4: type = ptr_type %.2 [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Main//c, inst+9, loaded [template = constants.%C]
// CHECK:STDOUT:   %import_ref.2 = import_ref Main//c, inst+7, unloaded
// CHECK:STDOUT:   %import_ref.3: %F.type = import_ref Main//c, inst+8, loaded [template = constants.%F]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C = imports.%import_ref.1
// CHECK:STDOUT:     .x = %x
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %.loc6_9.1: %.1 = tuple_literal ()
// CHECK:STDOUT:   %.loc6_9.2: type = converted %.loc6_9.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:   %x.var: ref %.1 = var x
// CHECK:STDOUT:   %x: ref %.1 = bind_name x, %x.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.2
// CHECK:STDOUT:   .F = imports.%import_ref.3
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %C.ref: type = name_ref C, imports.%import_ref.1 [template = constants.%C]
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.3 [template = constants.%F]
// CHECK:STDOUT:   %F.call: init %.1 = call %F.ref()
// CHECK:STDOUT:   assign file.%x.var, %F.call
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- use_d.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %.2: type = struct_type {} [template]
// CHECK:STDOUT:   %.3: <witness> = complete_type_witness %.2 [template]
// CHECK:STDOUT:   %.4: type = ptr_type %.2 [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Main//c, inst+9, loaded [template = constants.%C]
// CHECK:STDOUT:   %import_ref.2 = import_ref Main//c, inst+7, unloaded
// CHECK:STDOUT:   %import_ref.3: %F.type = import_ref Main//c, inst+8, loaded [template = constants.%F]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .C = imports.%import_ref.1
// CHECK:STDOUT:     .x = %x
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %.loc6_9.1: %.1 = tuple_literal ()
// CHECK:STDOUT:   %.loc6_9.2: type = converted %.loc6_9.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:   %x.var: ref %.1 = var x
// CHECK:STDOUT:   %x: ref %.1 = bind_name x, %x.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.2
// CHECK:STDOUT:   .F = imports.%import_ref.3
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %C.ref: type = name_ref C, imports.%import_ref.1 [template = constants.%C]
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.3 [template = constants.%F]
// CHECK:STDOUT:   %F.call: init %.1 = call %F.ref()
// CHECK:STDOUT:   assign file.%x.var, %F.call
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- use_e.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %D: type = class_type @D [template]
// CHECK:STDOUT:   %.2: type = struct_type {} [template]
// CHECK:STDOUT:   %.3: <witness> = complete_type_witness %.2 [template]
// CHECK:STDOUT:   %.4: type = ptr_type %.2 [template]
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Main//e, inst+3, loaded [template = constants.%D]
// CHECK:STDOUT:   %import_ref.2 = import_ref Main//e, inst+4, unloaded
// CHECK:STDOUT:   %import_ref.3: type = import_ref Main//e, inst+12, loaded [template = constants.%C]
// CHECK:STDOUT:   %import_ref.4 = import_ref Main//e, inst+9, unloaded
// CHECK:STDOUT:   %import_ref.5: %F.type = import_ref Main//e, inst+10, loaded [template = constants.%F]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .D = imports.%import_ref.1
// CHECK:STDOUT:     .x = %x
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %.loc6_9.1: %.1 = tuple_literal ()
// CHECK:STDOUT:   %.loc6_9.2: type = converted %.loc6_9.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:   %x.var: ref %.1 = var x
// CHECK:STDOUT:   %x: ref %.1 = bind_name x, %x.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @D {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.2
// CHECK:STDOUT:   .C = imports.%import_ref.3
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.4
// CHECK:STDOUT:   .F = imports.%import_ref.5
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %D.ref: type = name_ref D, imports.%import_ref.1 [template = constants.%D]
// CHECK:STDOUT:   %C.ref: type = name_ref C, imports.%import_ref.3 [template = constants.%C]
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.5 [template = constants.%F]
// CHECK:STDOUT:   %F.call: init %.1 = call %F.ref()
// CHECK:STDOUT:   assign file.%x.var, %F.call
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- use_f.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %D: type = class_type @D [template]
// CHECK:STDOUT:   %.2: type = struct_type {} [template]
// CHECK:STDOUT:   %.3: <witness> = complete_type_witness %.2 [template]
// CHECK:STDOUT:   %.4: type = ptr_type %.2 [template]
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: type = import_ref Main//e, inst+3, loaded [template = constants.%D]
// CHECK:STDOUT:   %import_ref.2 = import_ref Main//e, inst+4, unloaded
// CHECK:STDOUT:   %import_ref.3: type = import_ref Main//e, inst+12, loaded [template = constants.%C]
// CHECK:STDOUT:   %import_ref.4 = import_ref Main//e, inst+9, unloaded
// CHECK:STDOUT:   %import_ref.5: %F.type = import_ref Main//e, inst+10, loaded [template = constants.%F]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .D = imports.%import_ref.1
// CHECK:STDOUT:     .x = %x
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %.loc6_9.1: %.1 = tuple_literal ()
// CHECK:STDOUT:   %.loc6_9.2: type = converted %.loc6_9.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:   %x.var: ref %.1 = var x
// CHECK:STDOUT:   %x: ref %.1 = bind_name x, %x.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @D {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.2
// CHECK:STDOUT:   .C = imports.%import_ref.3
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.4
// CHECK:STDOUT:   .F = imports.%import_ref.5
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %D.ref: type = name_ref D, imports.%import_ref.1 [template = constants.%D]
// CHECK:STDOUT:   %C.ref: type = name_ref C, imports.%import_ref.3 [template = constants.%C]
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.5 [template = constants.%F]
// CHECK:STDOUT:   %F.call: init %.1 = call %F.ref()
// CHECK:STDOUT:   assign file.%x.var, %F.call
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
