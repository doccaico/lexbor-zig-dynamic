// src/core/array.zig

// const std = @import("std");

// const lb = @import("../lexbor.zig");

// pub const array = extern struct {
//     list: [*c]*anyopaque,
//     size: u32,
//     length: u32,
//
//     pub fn create() [*c]array {
//         return lexbor_array_create();
//     }
//
//     pub fn init(self: [*c]array, size: u32) lb.core.status {
//         return lexbor_array_init(self, size);
//     }
//
//     pub fn destroy(self: [*c]array, self_destroy: bool) [*c]array {
//         return lexbor_array_destroy(self, self_destroy);
//     }
//
//     pub fn expand(self: [*c]array, up_to: *anyopaque) lb.core.status {
//         return lexbor_array_expand(self, up_to);
//     }
//
//     pub fn push(self: [*c]array, value: *anyopaque) lb.core.status {
//         return lexbor_array_push(self, value);
//     }
//
//     pub fn pop(self: [*c]array) *anyopaque {
//         return lexbor_array_pop(self);
//     }
//
//     pub fn insert(self: [*c]array, idx: u32, value: *anyopaque) lb.core.status {
//         return lexbor_array_insert(self, idx, value);
//     }
//
//     pub fn set(self: [*c]array, idx: u32, value: *anyopaque) lb.core.status {
//         return lexbor_array_set(self, idx, value);
//     }
//
//     pub fn delete(self: [*c]array, begin: u32, length: u32) void {
//         return lexbor_array_delete(self, begin, length);
//     }
//
//     pub inline fn get(self: [*c]array, idx: u32) ?*anyopaque {
//         if (idx >= self.*.length) {
//             return null;
//         }
//         return self.*.list[idx];
//     }
//
//     pub inline fn lengthZ(self: [*c]array) u32 {
//         return self.*.length;
//     }
//
//     pub fn get_noi(self: [*c]array, idx: u32) *anyopaque {
//         return lexbor_array_get_noi(self, idx);
//     }
//
//     pub fn length_noi(self: [*c]array) u32 {
//         return lexbor_array_length_noi(self);
//     }
//
//     pub fn size_noi(self: [*c]array) u32 {
//         return lexbor_array_size_noi(self);
//     }
// };
//
// extern "c" fn lexbor_array_create() [*c]array;
// extern "c" fn lexbor_array_init(array: [*c]array, size: u32) lb.core.status;
// extern "c" fn lexbor_array_clean(array: [*c]array) void;
// extern "c" fn lexbor_array_destroy(array: [*c]array, self_destroy: bool) [*c]array;
// extern "c" fn lexbor_array_expand(array: [*c]array, up_to: u32) *anyopaque;
// extern "c" fn lexbor_array_push(array: [*c]array, value: *anyopaque) lb.core.status;
// extern "c" fn lexbor_array_pop(array: [*c]array) *anyopaque;
// extern "c" fn lexbor_array_insert(array: [*c]array, idx: u32, value: *anyopaque) lb.core.status;
// extern "c" fn lexbor_array_set(array: [*c]array, idx: u32, value: *anyopaque) lb.core.status;
// extern "c" fn lexbor_array_delete(array: [*c]array, begin: u32, length: u32) void;
// extern "c" fn lexbor_array_get_noi(array: [*c]array, idx: u32) *anyopaque;
// extern "c" fn lexbor_array_length_noi(array: [*c]array) u32;
// extern "c" fn lexbor_array_size_noi(array: [*c]array) u32;
