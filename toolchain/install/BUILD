# Part of the Carbon Language project, under the Apache License v2.0 with LLVM
# Exceptions. See /LICENSE for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@llvm-project//llvm:binary_alias.bzl", "binary_alias")
load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library", "cc_test")
load("@rules_pkg//pkg:mappings.bzl", "pkg_attributes", "pkg_filegroup", "pkg_files", "pkg_mklink", "strip_prefix")
load("pkg_helpers.bzl", "pkg_naming_variables", "pkg_tar_and_test")
load("run_tool.bzl", "run_tool")
load("symlink_filegroup.bzl", "symlink_filegroup")

package(default_visibility = ["//visibility:public"])

# Build rules supporting the install data tree for the Carbon toolchain.
#
# This populates a synthetic Carbon toolchain installation under the
# `prefix_root` directory. For details on its layout, see `install_paths.h`.

# A marker of a valid Carbon install. All filegroups in the install should
# include this one.
write_file(
    name = "install_marker",
    out = "prefix_root/lib/carbon/carbon_install.txt",
    content = [
        "// Part of the Carbon Language project, under the Apache License v2.0 with LLVM",
        "// Exceptions. See /LICENSE for license information.",
        "// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception",
        "",
        "This marks a valid Carbon install tree.",
    ],
)

# Create symlinks for the core library. Note that this should *not* be depended
# on directly, use `:core_data` instead.
symlink_filegroup(
    name = "symlink_core",
    srcs = ["//core:prelude"],
    out_prefix = "prefix_root/lib/carbon/core/",
    visibility = ["//visibility:private"],
)

# The filegroup to get the core library.
filegroup(
    name = "core_data",
    srcs = [
        ":install_marker",
        ":symlink_core",
    ],
)

# Copy Clang and LLVM toolchain files into a synthetic LLVM installation under
# `prefix_root/lib/carbon/llvm` so that parts of Clang that expect to find an LLVM
# installation at relative paths work correctly without exposing these in an
# installed 'bin' directory where it might get added to a user's PATH.
binary_alias(
    name = "prefix_root/lib/carbon/llvm/bin/lld",
    binary = "@llvm-project//lld:lld",
)

binary_alias(
    name = "prefix_root/lib/carbon/language_server/bin/language_server",
    binary = "//language_server:language_server",
)

lld_bin_names = [
    "ld.lld",
    "ld64.lld",
    "lld-link",
    "wasm-ld",
]

language_server_bin_names = [
    # "language_server", # This is already symlinked in the `prefix_root` directory.
]

[
    binary_alias(
        name = "prefix_root/lib/carbon/llvm/bin/" + bin_name,
        binary = "@llvm-project//lld:lld",
    )
    for bin_name in lld_bin_names
]

[
    binary_alias(
        name = "prefix_root/lib/carbon/language_server/bin/" + bin_name,
        binary = "//language_server:language_server",
    )
    for bin_name in language_server_bin_names
]

filegroup(
    name = "llvm_link_data",
    srcs = [
        "prefix_root/lib/carbon/llvm/bin/lld",
        ":install_marker",
    ] + [
        "prefix_root/lib/carbon/llvm/bin/" + bin_name
        for bin_name in lld_bin_names
    ],
)

filegroup(
    name = "language_server_link_data",
    srcs = [
        "prefix_root/lib/carbon/language_server/bin/language_server",
        ":install_marker",
    ] + [
        "prefix_root/lib/carbon/language_server/bin/" + bin_name
        for bin_name in language_server_bin_names
    ],
)

# All of the install data except for the user-facing binaries. This is typically
# a reasonable data dependency for libraries and the user-facing binaries
# without creating a cycle.
filegroup(
    name = "install_lib_data",
    srcs = [
        ":core_data",
        ":install_marker",
        ":llvm_link_data",
        ":language_server_link_data",
    ],
)

binary_alias(
    name = "prefix_root/bin/carbon",
    binary = "//toolchain/driver:carbon",
)

filegroup(
    name = "install_data",
    srcs = [
        "prefix_root/bin/carbon",
        ":install_lib_data",
        ":install_marker",
    ],
)

# A library for computing install paths for the toolchain. Note that this
# library does *not* include the data itself, as that would form a dependency
# cycle. Each part of the toolchain should add the narrow data file groups to
# their data dependencies, and then use this library to locate them.
cc_library(
    name = "install_paths",
    srcs = ["install_paths.cpp"],
    hdrs = ["install_paths.h"],
    deps = [
        "//common:check",
        "//common:error",
        "@bazel_tools//tools/cpp/runfiles",
        "@llvm-project//llvm:Support",
    ],
)

cc_binary(
    name = "test_binary",
    testonly = 1,
    srcs = ["test_binary.cpp"],
    data = [":install_data"],
)

cc_test(
    name = "install_paths_test",
    size = "small",
    srcs = ["install_paths_test.cpp"],
    data = [
        ":install_data",
        ":test_binary",
    ],
    deps = [
        ":install_paths",
        "//common:check",
        "//common:ostream",
        "//testing/base:global_exe_path",
        "//testing/base:gtest_main",
        "@bazel_tools//tools/cpp/runfiles",
        "@googletest//:gtest",
        "@llvm-project//llvm:Support",
    ],
)

cc_library(
    name = "install_paths_test_helpers",
    testonly = 1,
    srcs = ["install_paths_test_helpers.cpp"],
    hdrs = ["install_paths_test_helpers.h"],
    deps = [
        ":install_paths",
        "//testing/base:global_exe_path",
        "@llvm-project//llvm:Support",
    ],
)

# Build rules to construct packaged versions of the toolchain's install.

pkg_files(
    name = "packaging_exe_files",
    # We break out the driver and LLD here because we can't easily use file
    # groups that contain symlinks, so those are manually handled below. Other
    # file groups should be directly included.
    srcs = [
        "prefix_root/bin/carbon",
        "prefix_root/lib/carbon/llvm/bin/lld",
        "prefix_root/lib/carbon/language_server/bin/language_server",
    ],
    attributes = pkg_attributes(mode = "0755"),
    strip_prefix = strip_prefix.from_pkg("prefix_root"),
)

# Currently, `rules_pkg` can't replicate symlinks from the main tree. To an
# extent, this is reasonable because we want to be much more explicit about the
# symlink structure in the package where as for the filegroups we're comfortable
# with whatever "just works" for development and testing.
[
    pkg_mklink(
        name = "packaging_link_lld_alias_" + bin_name,
        link_name = "lib/carbon/llvm/bin/" + bin_name,
        target = "lld",
    )
    for bin_name in lld_bin_names
]

[
    pkg_mklink(
        name = "packaging_link_language_server_alias_" + bin_name,
        link_name = "lib/carbon/language_server/bin/" + bin_name,
        target = "language_server",
    )
    for bin_name in language_server_bin_names
]

pkg_files(
    name = "packaging_data_files",
    srcs = [
        ":core_data",
    ],
    strip_prefix = strip_prefix.from_pkg("prefix_root"),
)

pkg_filegroup(
    name = "packaging_files",
    srcs = [
        ":packaging_data_files",
        ":packaging_exe_files",
    ] + [
        ":packaging_link_lld_alias_" + bin_name
        for bin_name in lld_bin_names
    ] + [
        ":packaging_link_language_server_alias_" + bin_name
        for bin_name in language_server_bin_names
    ],
)

pkg_naming_variables(
    name = "packaging_variables",
)

# We build both a compressed and uncompressed tar file with the same code here.
# This lets us use the tar file in testing as it is fast to create, but ship the
# compressed version as a release.

config_setting(
    name = "macos_amd64",
    constraint_values = [
        "@platforms//os:osx",
        "@platforms//cpu:x86_64",
    ],
)

config_setting(
    name = "macos_arm64",
    constraint_values = [
        "@platforms//os:osx",
        "@platforms//cpu:arm64",
    ],
)

pkg_tar_and_test(
    srcs = [":packaging_files"],
    name_base = "carbon_toolchain",
    package_dir = select({
        ":macos_amd64": "carbon_toolchain-$(version)-macos-amd64",
        ":macos_arm64": "carbon_toolchain-$(version)-macos-arm64",
        "//conditions:default": "carbon_toolchain-$(version)",
    }),
    package_file_name_base = select({
        ":macos_amd64": "carbon_toolchain-$(version)-macos-amd64",
        ":macos_arm64": "carbon_toolchain-$(version)-macos-arm64",
        "//conditions:default": "carbon_toolchain-$(version)",
    }),
    package_variables = ":packaging_variables",
    stamp = -1,  # Allow `--stamp` builds to produce file timestamps.
    test_data = [
        ":install_data",
    ],
    test_install_marker = ":install_marker",
)

# Support `bazel run` on specific binaries.
run_tool(
    name = "run_carbon",
    data = [":install_data"],
    tool = "prefix_root/bin/carbon",
)
