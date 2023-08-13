// -------------------------------------------------------------------------- //
// Copyright (c) 2019, Jairus Martin.                                         //
// Distributed under the terms of the MIT License.                            //
// The full license is in the file LICENSE, distributed with this software.   //
// -------------------------------------------------------------------------- //

const std = @import("std");
const zigwin32 = @import("zigwin32");

const Timezone = @import("datetime.zig").Timezone;
const create = Timezone.create;

pub const UTC = create("UTC", 0);
pub const WET = create("WET", 0);

pub fn get_system_timezone(allocator: std.mem.Allocator) !Timezone {
    const system_time = std.time.timestamp();
    const tzfile = try std.fs.cwd().openFile("/etc/localtime", .{});
    const timezones = try std.Tz.parse(allocator, tzfile.reader());
    var current_timetype: std.tz.Timetype = undefined;

    for (timezones.transitions, 0..) |transition, idx| {
        if (transition.ts > 0 and system_time < transition.ts) {
            current_timetype = timezones.transitions[idx - 1].timetype.*;
            break;
        }
    }

    const name = current_timetype.name();
    const offset: i16 = @intCast(@divFloor(current_timetype.offset, 3600));

    const System = Timezone.create(name, offset);
    return System;
}
