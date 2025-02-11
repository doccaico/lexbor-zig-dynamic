const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

const lb = @import("lexbor");

pub const avl_test_ctx = struct {
    remove: usize,
    result: ?*usize,
    p: ?*usize,
};

pub const avl_cb = *const fn (avl: ?*lb.core.avl, root: ?*?*lb.core.avl_node, node: ?*lb.core.avl_node, ctx: ?*anyopaque) callconv(.C) lb.core.status;

test "init" {
    var avl = lb.core.avl.create().?;
    const status = avl.init(1024, 0);

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = avl.destroy(true);
}

test "init_null" {
    const status = lb.core.avl.init(null, 1024, 0);
    try expectEqual(status, @intFromEnum(lb.core.Status.error_object_is_null));
}

test "init_stack" {
    var avl: lb.core.avl = undefined;
    const status = avl.init(1024, 0);

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = avl.destroy(false);
}

test "init_args" {
    var avl = lb.core.avl{ .nodes = null, .last_right = null };
    const status = avl.init(0, 0);

    try expectEqual(status, @intFromEnum(lb.core.Status.error_wrong_args));

    _ = avl.destroy(false);
}
