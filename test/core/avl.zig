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

test "node_make" {
    var avl: lb.core.avl = undefined;
    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    const node = avl.node_make(1, &avl);

    try expect(node != null);

    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expectEqual(node.?.parent, null);
    try expectEqual(node.?.height, 0);
    try expectEqual(node.?.type, 1);
    try expectEqual(node.?.value.?, @as(*anyopaque, @ptrCast(&avl)));

    _ = avl.destroy(false);
}

test "node_clean" {
    var avl: lb.core.avl = undefined;
    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    var node = avl.node_make(1, &avl);

    try expect(node != null);

    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expectEqual(node.?.parent, null);
    try expectEqual(node.?.height, 0);
    try expectEqual(node.?.type, 1);
    try expectEqual(node.?.value, @as(*anyopaque, @ptrCast(&avl)));

    node.?.clean();

    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expectEqual(node.?.parent, null);
    try expectEqual(node.?.height, 0);
    try expectEqual(node.?.type, 0);
    try expectEqual(node.?.value, null);

    _ = avl.destroy(false);
}

test "node_destroy" {
    var avl = lb.core.avl.create().?;
    _ = avl.init(1024, 0);

    var node = avl.node_make(1, avl);

    try expect(node != null);

    try expectEqual(avl.node_destroy(node, true), null);

    node = avl.node_make(1, avl);
    try expect(node != null);

    try expectEqual(avl.node_destroy(node, false), node);
    try expectEqual(avl.node_destroy(null, false), null);

    _ = avl.destroy(true);
}

fn test_for_three(avl: *lb.core.avl, root: ?*lb.core.avl_node) !void {
    var node: ?*lb.core.avl_node = undefined;

    try expect(root != null);
    try expectEqual(root.?.type, 2);

    // 1
    node = avl.search(root, 1);
    try expect(node != null);

    try expectEqual(node.?.type, 1);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 2);

    // 2
    node = node.?.parent;
    try expect(node != null);

    try expectEqual(node.?.type, 2);

    try expect(node.?.left != null);
    try expectEqual(node.?.left.?.type, 1);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 3);

    try expectEqual(node.?.parent, null);

    // 3
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 3);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 2);
}

test "three_3_0" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));

    try test_for_three(&avl, root);

    _ = avl.destroy(false);
}

test "three_3_1" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));
    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));

    try test_for_three(&avl, root);

    _ = avl.destroy(false);
}

test "three_3_2" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));

    try test_for_three(&avl, root);

    _ = avl.destroy(false);
}

test "three_3_3" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));
    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));

    try test_for_three(&avl, root);

    _ = avl.destroy(false);
}

test "three_3_4" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));
    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));

    try test_for_three(&avl, root);

    _ = avl.destroy(false);
}

test "three_3_5" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));
    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));

    try test_for_three(&avl, root);

    _ = avl.destroy(false);
}

test "tree_4" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;
    var node: ?*lb.core.avl_node = undefined;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));
    _ = avl.insert(&root, 4, @as(*anyopaque, @ptrFromInt(4)));

    // 1
    node = avl.search(root, 1);
    try expect(node != null);

    try expectEqual(node.?.type, 1);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 2);

    // 2
    node = node.?.parent;
    try expect(node != null);

    try expectEqual(node.?.type, 2);

    try expect(node.?.left != null);
    try expectEqual(node.?.left.?.type, 1);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 3);

    try expectEqual(node.?.parent, null);

    // 3
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 3);
    try expectEqual(node.?.left, null);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 4);

    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 2);

    // 4
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 4);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 3);

    _ = avl.destroy(false);
}

test "tree_5" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;
    var node: ?*lb.core.avl_node = undefined;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));
    _ = avl.insert(&root, 4, @as(*anyopaque, @ptrFromInt(4)));
    _ = avl.insert(&root, 5, @as(*anyopaque, @ptrFromInt(5)));

    // 1
    node = avl.search(root, 1);
    try expect(node != null);

    try expectEqual(node.?.type, 1);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 2);

    // 2
    node = node.?.parent;
    try expect(node != null);

    try expectEqual(node.?.type, 2);

    try expect(node.?.left != null);
    try expectEqual(node.?.left.?.type, 1);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 4);

    try expectEqual(node.?.parent, null);

    // 4
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 4);

    try expect(node.?.left != null);
    try expectEqual(node.?.left.?.type, 3);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 5);

    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 2);

    // 3
    node = node.?.left;
    try expect(node != null);

    try expectEqual(node.?.type, 3);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 4);

    // 5
    node = node.?.parent.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 5);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 4);

    _ = avl.destroy(false);
}

test "delete_1L" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;
    var node: ?*lb.core.avl_node = undefined;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));
    _ = avl.insert(&root, 4, @as(*anyopaque, @ptrFromInt(4)));

    try expect(root != null);

    try expect(avl.remove(&root, 1) != null);
    try expect(root != null);

    // 2
    node = avl.search(root, 2);
    try expect(node != null);

    try expectEqual(node.?.type, 2);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 3);

    // 3
    node = node.?.parent;
    try expect(node != null);

    try expectEqual(node.?.type, 3);

    try expect(node.?.left != null);
    try expectEqual(node.?.left.?.type, 2);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 4);

    try expectEqual(node.?.parent, null);

    // 4
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 4);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 3);

    _ = avl.destroy(false);
}

test "delete_1R" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;
    var node: ?*lb.core.avl_node = undefined;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));
    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 4, @as(*anyopaque, @ptrFromInt(4)));

    try expect(root != null);

    try expect(avl.remove(&root, 4) != null);
    try expect(root != null);

    // 1
    node = avl.search(root, 1);
    try expect(node != null);

    try expectEqual(node.?.type, 1);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 2);

    // 2
    node = node.?.parent;
    try expect(node != null);

    try expectEqual(node.?.type, 2);

    try expect(node.?.left != null);
    try expectEqual(node.?.left.?.type, 1);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 3);

    try expectEqual(node.?.parent, null);

    // 3
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 3);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 2);

    _ = avl.destroy(false);
}

test "delete_2L" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;
    var node: ?*lb.core.avl_node = undefined;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 4, @as(*anyopaque, @ptrFromInt(4)));
    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));

    try expect(root != null);

    try expect(avl.remove(&root, 1) != null);
    try expect(root != null);

    // 2
    node = avl.search(root, 2);
    try expect(node != null);

    try expectEqual(node.?.type, 2);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 3);

    // 3
    node = node.?.parent;
    try expect(node != null);

    try expectEqual(node.?.type, 3);

    try expect(node.?.left != null);
    try expectEqual(node.?.left.?.type, 2);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 4);

    try expectEqual(node.?.parent, null);

    // 4
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 4);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 3);

    _ = avl.destroy(false);
}

test "delete_2R" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;
    var node: ?*lb.core.avl_node = undefined;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));
    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 4, @as(*anyopaque, @ptrFromInt(4)));

    try expect(root != null);

    try expect(avl.remove(&root, 4) != null);
    try expect(root != null);

    // 1
    node = avl.search(root, 1);
    try expect(node != null);

    try expectEqual(node.?.type, 1);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 2);

    // 2
    node = node.?.parent;
    try expect(node != null);

    try expectEqual(node.?.type, 2);

    try expect(node.?.left != null);
    try expectEqual(node.?.left.?.type, 1);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 3);

    try expectEqual(node.?.parent, null);

    // 3
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 3);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 2);

    _ = avl.destroy(false);
}

test "delete_sub_1L" {
    var avl: lb.core.avl = undefined;
    var root: ?*lb.core.avl_node = null;
    var node: ?*lb.core.avl_node = undefined;

    try expectEqual(avl.init(1024, 0), @intFromEnum(lb.core.Status.ok));

    _ = avl.insert(&root, 3, @as(*anyopaque, @ptrFromInt(3)));
    _ = avl.insert(&root, 2, @as(*anyopaque, @ptrFromInt(2)));
    _ = avl.insert(&root, 5, @as(*anyopaque, @ptrFromInt(5)));
    _ = avl.insert(&root, 1, @as(*anyopaque, @ptrFromInt(1)));
    _ = avl.insert(&root, 4, @as(*anyopaque, @ptrFromInt(4)));
    _ = avl.insert(&root, 6, @as(*anyopaque, @ptrFromInt(6)));
    _ = avl.insert(&root, 7, @as(*anyopaque, @ptrFromInt(7)));

    try expect(root != null);

    try expect(avl.remove(&root, 1) != null);
    try expect(root != null);

    // 2
    node = avl.search(root, 2);
    try expect(node != null);

    try expectEqual(node.?.type, 2);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 3);

    // 3
    node = node.?.parent;
    try expect(node != null);

    try expectEqual(node.?.type, 3);

    try expect(node.?.left != null);
    try expectEqual(node.?.left.?.type, 2);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 4);

    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 5);

    // 4
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 4);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 3);

    // 5
    node = node.?.parent.?.parent;
    try expect(node != null);

    try expectEqual(node.?.type, 5);

    try expect(node.?.left != null);
    try expectEqual(node.?.left.?.type, 3);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 6);

    try expectEqual(node.?.parent, null);

    // 6
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 6);
    try expectEqual(node.?.left, null);

    try expect(node.?.right != null);
    try expectEqual(node.?.right.?.type, 7);

    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 5);

    // 7
    node = node.?.right;
    try expect(node != null);

    try expectEqual(node.?.type, 7);
    try expectEqual(node.?.left, null);
    try expectEqual(node.?.right, null);
    try expect(node.?.parent != null);
    try expectEqual(node.?.parent.?.type, 6);

    _ = avl.destroy(false);
}
