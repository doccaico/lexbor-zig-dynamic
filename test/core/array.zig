const std = @import("std");
const expect = std.testing.expect;

// const lb = @import("../../lexbor.zig");
// const lb = @import("../../src/lexbor.zig");
const lb = @import("lexbor");

test "init" {
    var array = lb.core.array.create();
    const status = lb.core.array.init(array, 32);

    try expect(status == @intFromEnum(lb.core.Status.ok));
    try expect(1 == 1);

    _ = array.destroy(true);
}

// pub fn main() !void {
//     try expect(1 == 2);
//     // print("Hi\n", .{});
//     // try expect(1 == 2);
// }
// test addOne {
//     // A test name can also be written using an identifier.
//     // This is a doctest, and serves as documentation for `addOne`.
//     try std.testing.expect(addOne(41) == 42);
// }
//
