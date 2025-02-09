// src/core/array.zig

const lb = @import("../lexbor.zig");

pub const Array = extern struct {
    list: **anyopaque,
    size: u32,
    length: u32,
};

pub fn create() *lb.core.Array {
    return lexbor_array_create();
}

pub fn init(array: [*c]lb.core.Array, size: u32) lb.core.status {
    return lexbor_array_init(array, size);
}

extern "c" fn lexbor_array_create() [*c]lb.core.Array;
extern "c" fn lexbor_array_init(array: [*c]lb.core.Array, size: u32) lb.core.status;
