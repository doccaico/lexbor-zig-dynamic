const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/lexbor.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    const unit_tests = b.addTest(.{
        .root_source_file = b.path("test/unit_tests.zig"),
    });

    unit_tests.root_module.addImport("lexbor", lib_mod);
    unit_tests.addLibraryPath(b.path("lib"));
    unit_tests.linkSystemLibrary("lexbor");

    const install_exe_unit_test = b.addInstallArtifact(unit_tests, .{});
    install_exe_unit_test.step.dependOn(b.getInstallStep());

    const run_exe_unit_tests = b.addRunArtifact(unit_tests);
    run_exe_unit_tests.step.dependOn(&install_exe_unit_test.step);

    const test_all_step = b.step("test", "Run all tests");
    test_all_step.dependOn(&run_exe_unit_tests.step);

    b.installBinFile("lib/lexbor.dll", "lexbor.dll");
}
