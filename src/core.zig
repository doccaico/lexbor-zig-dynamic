// src/core.zig
const std = @import("std");

const lb = @import("lexbor.zig");

// core/array.zig

pub const array = extern struct {
    list: [*]*anyopaque,
    size: usize,
    length: usize,

    pub fn create() *array {
        return lexbor_array_create();
    }

    pub fn init(self: ?*array, size: usize) status {
        return lexbor_array_init(self, size);
    }

    pub fn clean(self: *array) void {
        return lexbor_array_clean(self);
    }

    pub fn destroy(self: ?*array, self_destroy: bool) *array {
        return lexbor_array_destroy(self, self_destroy);
    }

    pub fn expand(self: *array, up_to: usize) ?**anyopaque {
        return lexbor_array_expand(self, up_to);
    }

    pub fn push(self: *array, value: ?*anyopaque) status {
        return lexbor_array_push(self, value);
    }

    pub fn pop(self: *array) *anyopaque {
        return lexbor_array_pop(self);
    }

    pub fn insert(self: *array, idx: usize, value: *anyopaque) status {
        return lexbor_array_insert(self, idx, value);
    }

    pub fn set(self: *array, idx: usize, value: *anyopaque) status {
        return lexbor_array_set(self, idx, value);
    }

    pub fn delete(self: *array, begin: usize, length: usize) void {
        return lexbor_array_delete(self, begin, length);
    }

    pub inline fn get(self: *array, idx: usize) ?*anyopaque {
        if (idx >= self.length) {
            return null;
        }
        return self.list[idx];
    }

    pub fn get_noi(self: *array, idx: usize) *anyopaque {
        return lexbor_array_get_noi(self, idx);
    }

    pub fn length_noi(self: *array) usize {
        return lexbor_array_length_noi(self);
    }

    pub fn size_noi(self: *array) usize {
        return lexbor_array_size_noi(self);
    }
};

extern "c" fn lexbor_array_create() *array;
extern "c" fn lexbor_array_init(array: ?*array, size: usize) status;
extern "c" fn lexbor_array_clean(array: *array) void;
extern "c" fn lexbor_array_destroy(array: ?*array, self_destroy: bool) *array;
extern "c" fn lexbor_array_expand(array: *array, up_to: usize) **anyopaque;
extern "c" fn lexbor_array_push(array: *array, value: ?*anyopaque) status;
extern "c" fn lexbor_array_pop(array: *array) *anyopaque;
extern "c" fn lexbor_array_insert(array: *array, idx: usize, value: *anyopaque) status;
extern "c" fn lexbor_array_set(array: *array, idx: usize, value: *anyopaque) status;
extern "c" fn lexbor_array_delete(array: *array, begin: usize, length: usize) void;
extern "c" fn lexbor_array_get_noi(array: *array, idx: usize) *anyopaque;
extern "c" fn lexbor_array_length_noi(array: *array) usize;
extern "c" fn lexbor_array_size_noi(array: *array) usize;

// core/array_obj.zig

pub const array_obj = extern struct {
    list: [*]u8,
    size: usize,
    length: usize,
    struct_size: usize,

    pub fn create() *array_obj {
        return lexbor_array_obj_create();
    }

    pub fn init(self: ?*array_obj, size: usize, struct_size: usize) status {
        return lexbor_array_obj_init(self, size, struct_size);
    }

    pub fn clean(self: *array_obj) void {
        return lexbor_array_obj_clean(self);
    }

    pub fn destroy(self: ?*array_obj, self_destroy: bool) *array_obj {
        return lexbor_array_obj_destroy(self, self_destroy);
    }

    pub fn expand(self: *array_obj, up_to: usize) ?*u8 {
        return lexbor_array_obj_expand(self, up_to);
    }

    pub fn push(self: *array_obj) ?*anyopaque {
        return lexbor_array_obj_push(self);
    }

    pub fn push_wo_cls(self: *array_obj) *anyopaque {
        return lexbor_array_obj_push_wo_cls(self);
    }

    pub fn push_n(self: *array_obj, count: usize) *anyopaque {
        return lexbor_array_obj_push_wo_cls(self, count);
    }

    pub fn pop(self: *array_obj) *anyopaque {
        return lexbor_array_obj_pop(self);
    }

    pub fn delete(self: *array_obj, begin: usize, length: usize) void {
        return lexbor_array_obj_delete(self, begin, length);
    }

    pub inline fn erase(self: *array_obj) void {
        const slice = std.mem.asBytes(self);
        @memset(slice, 0);
    }

    pub inline fn get(self: *array_obj, idx: usize) ?*anyopaque {
        if (idx >= self.length) {
            return null;
        }
        return self.list + (idx * self.struct_size);
    }

    pub inline fn last(self: *array_obj) ?*anyopaque {
        if (self.length == 0) {
            return null;
        }
        return self.list + ((self.length - 1) * self.struct_size);
    }
};

extern "c" fn lexbor_array_obj_create() *array_obj;
extern "c" fn lexbor_array_obj_init(array: ?*array_obj, size: usize, struct_size: usize) status;
extern "c" fn lexbor_array_obj_clean(array: *array_obj) void;
extern "c" fn lexbor_array_obj_destroy(array: ?*array_obj, self_destroy: bool) *array_obj;
extern "c" fn lexbor_array_obj_expand(array: *array_obj, up_to: usize) ?*u8;
extern "c" fn lexbor_array_obj_push(array: *array_obj) ?*anyopaque;
extern "c" fn lexbor_array_obj_push_wo_cls(array: *array_obj) *anyopaque;
extern "c" fn lexbor_array_obj_push_n(array: *array_obj, count: usize) *anyopaque;
extern "c" fn lexbor_array_obj_pop(array: *array_obj) *anyopaque;
extern "c" fn lexbor_array_obj_delete(array: *array_obj, begin: usize, length: usize) void;
extern "c" fn lexbor_array_obj_erase_noi(array: *array_obj) void;
extern "c" fn lexbor_array_obj_get_noi(array: *array_obj, idx: usize) *anyopaque;
extern "c" fn lexbor_array_obj_length_noi(array: *array_obj) usize;
extern "c" fn lexbor_array_obj_size_noi(array: *array_obj) usize;
extern "c" fn lexbor_array_obj_struct_size_noi(array: *array_obj) usize;
extern "c" fn lexbor_array_obj_last_noi(array: *array_obj) *anyopaque;

// core/base.zig

pub const Status = enum(c_int) {
    ok = 0x0000,
    @"error" = 0x0001,
    error_memory_allocation,
    error_object_is_null,
    error_small_buffer,
    error_incomplete_object,
    error_no_free_slot,
    error_too_small_size,
    error_not_exists,
    error_wrong_args,
    error_wrong_stage,
    error_unexpected_result,
    error_unexpected_data,
    error_overflow,
    @"continue",
    small_buffer,
    aborted,
    stopped,
    next,
    stop,
    warning,
};

// core/types.zig

pub const status = c_uint;
