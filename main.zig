const std = @import("std");
const print = std.debug.print;
// const fmt = std.fmt;
// const mem = std.mem;
// const assert = std.debug.assert;
// const expect = std.testing.expect;

const lb = @import("lexbor");

pub fn main() !void {
    // print("{}\n", .{lb.PI});
    {
        const array = lb.core.array.create();
        _ = array;
    }
    {
        var array: lb.core.Array = undefined;
        const status = lb.core.array.init(&array, 32);
        _ = status;
    }
    {
        const status = lb.core.array.init(null, 32);
        _ = status;
    }
}
