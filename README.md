# Chrono


A fork of the zig-datetime module that supports DST by fetching the local system time on Unix-like operating systems. 

The dependency on zigwin32 is intended to add similar timezone-fetching capabilities on Windows machines, but I do not want to mess with converting the type returned from `DYNAMIC_TIME_ZONE_INFORMATION` to the type required for timezone names at the moment.PRs implementing this functionality would be more than welcome.



```zig

const allocator = std.heap.page_allocator;
const date = try Date.create(2019, 12, 25);
const next_year = date.shiftDays(7);
assert(next_year.year == 2020);
assert(next_year.month == 1);
assert(next_year.day == 1);

// In UTC
const now = Datetime.now();
const now_str = try now.formatHttp(allocator);
defer allocator.free(now_str);
std.debug.warn("The time is now: {}\n", .{now_str});
// The time is now: Fri, 20 Dec 2019 22:03:02 UTC


```
