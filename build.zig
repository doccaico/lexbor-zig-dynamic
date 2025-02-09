const std = @import("std");

const Lib = struct {
    path: []const u8,
    import_name: []const u8,
};

const libs = [_]Lib{
    .{ .path = "src/lexbor.zig", .import_name = "lexbor" },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });

    for (libs) |lib| {
        const mod = b.createModule(.{
            .root_source_file = b.path(lib.path),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        });
        exe_mod.addImport(lib.import_name, mod);
    }

    const exe = b.addExecutable(.{
        .name = "basic",
        .root_module = exe_mod,
        .linkage = .dynamic,
    });

    exe.addLibraryPath(b.path("./lib"));
    exe.linkSystemLibrary("lexbor");

    b.installBinFile("lib/lexbor.dll", "lexbor.dll");

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
