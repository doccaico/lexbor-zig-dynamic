// src/core.zig

const lb = @import("lexbor.zig");

// core/array.zig

// pub const array = @import("core/array.zig").array;

pub const array = extern struct {
    list: [*c]*anyopaque,
    size: usize,
    length: usize,

    pub fn create() *array {
        return lexbor_array_create();
    }

    pub fn init(self: [*c]array, size: usize) lb.core.status {
        return lexbor_array_init(self, size);
    }

    pub fn clean(self: [*c]array) void {
        return lexbor_array_clean(self);
    }

    pub fn destroy(self: [*c]array, self_destroy: bool) [*c]array {
        return lexbor_array_destroy(self, self_destroy);
    }

    pub fn expand(self: [*c]array, up_to: usize) ?**anyopaque {
        return lexbor_array_expand(self, up_to);
    }

    pub fn push(self: [*c]array, value: ?*anyopaque) lb.core.status {
        return lexbor_array_push(self, value);
    }

    pub fn pop(self: [*c]array) *anyopaque {
        return lexbor_array_pop(self);
    }

    pub fn insert(self: [*c]array, idx: usize, value: *anyopaque) lb.core.status {
        return lexbor_array_insert(self, idx, value);
    }

    pub fn set(self: [*c]array, idx: usize, value: *anyopaque) lb.core.status {
        return lexbor_array_set(self, idx, value);
    }

    pub fn delete(self: [*c]array, begin: usize, length: usize) void {
        return lexbor_array_delete(self, begin, length);
    }

    pub inline fn get(self: [*c]array, idx: usize) ?*anyopaque {
        if (idx >= self.*.length) {
            return null;
        }
        return self.*.list[idx];
    }

    pub fn get_noi(self: [*c]array, idx: usize) ?*anyopaque {
        return lexbor_array_get_noi(self, idx);
    }

    pub fn length_noi(self: [*c]array) usize {
        return lexbor_array_length_noi(self);
    }

    pub fn size_noi(self: [*c]array) usize {
        return lexbor_array_size_noi(self);
    }
};

pub extern "c" fn lexbor_array_create() [*c]array;
pub extern "c" fn lexbor_array_init(array: [*c]array, size: usize) lb.core.status;
pub extern "c" fn lexbor_array_clean(array: [*c]array) void;
pub extern "c" fn lexbor_array_destroy(array: [*c]array, self_destroy: bool) [*c]array;
pub extern "c" fn lexbor_array_expand(array: [*c]array, up_to: usize) **anyopaque;
pub extern "c" fn lexbor_array_push(array: [*c]array, value: ?*anyopaque) lb.core.status;
pub extern "c" fn lexbor_array_pop(array: [*c]array) *anyopaque;
pub extern "c" fn lexbor_array_insert(array: [*c]array, idx: usize, value: *anyopaque) lb.core.status;
pub extern "c" fn lexbor_array_set(array: [*c]array, idx: usize, value: *anyopaque) lb.core.status;
pub extern "c" fn lexbor_array_delete(array: [*c]array, begin: usize, length: usize) void;
pub extern "c" fn lexbor_array_get_noi(array: [*c]array, idx: usize) ?*anyopaque;
pub extern "c" fn lexbor_array_length_noi(array: [*c]array) usize;
pub extern "c" fn lexbor_array_size_noi(array: [*c]array) usize;

// core/base.zig

pub const Status = @import("core/base.zig").Status;

// core/types.zig

pub const status = @import("core/types.zig").status;
