const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
const print = std.debug.print;
const assert = std.debug.assert;
const expect = std.testing.expect;

pub fn main() !void {
    var arr = [_]i8{ 0, 1, 2, 3, 4, 5 };
    var p = &arr[0];

    p = @ptrFromInt(@intFromPtr(p) + @sizeOf(i8));
    p = @ptrFromInt(@intFromPtr(p) + @sizeOf(i8));
    p = @ptrFromInt(@intFromPtr(p) + @sizeOf(i8));
    p = @ptrFromInt(@intFromPtr(p) + @sizeOf(i8));
    p = @ptrFromInt(@intFromPtr(p) + @sizeOf(i8));
    p = @ptrFromInt(@intFromPtr(p) + @sizeOf(i8));
    p = @ptrFromInt(@intFromPtr(p) + @sizeOf(i8));
    // p = @intFromPtr(p) + @sizeOf(i8);

    print("{d}\n", .{arr[0]});
    print("{d}\n", .{p.*});
}
// zig test filename.zig
// test "if" {
//     try expect(1 == 1);
// }
//  const stdout = std.io.getStdOut().writer();
//  const message: []const u8 = "Hello, World!";
//  try stdout.print("{s}\n", .{message});
