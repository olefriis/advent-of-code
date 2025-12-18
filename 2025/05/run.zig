const std = @import("std");

const Range = struct {
    start: u64,
    end: u64,
};

fn covered(id: u64, ranges: []const Range) bool {
    for (ranges) |range| {
        if (id >= range.start and id <= range.end) {
            return true;
        }
    }
    return false;
}

fn rangeComparison(context: void, a: Range, b: Range) bool {
    _ = context;
    return a.start < b.start;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read the input file
    const file = try std.fs.cwd().openFile("05/input", .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    const bytes_read = try file.read(buffer);
    const content = buffer[0..bytes_read];

    var lines = std.mem.splitScalar(u8, content, '\n');

    // First, get the ranges
    var ranges = std.ArrayList(Range).empty;

    defer ranges.deinit(allocator);
    while (lines.next()) |line| {
        // The ranges end with an empty line
        if (line.len == 0) break;

        var parts = std.mem.splitScalar(u8, line, '-');
        const start_str = parts.next() orelse continue;
        const end_str = parts.next() orelse continue;

        const start = try std.fmt.parseInt(u64, start_str, 10);
        const end = try std.fmt.parseInt(u64, end_str, 10);
        try ranges.append(allocator, Range{ .start = start, .end = end });
    }

    // Sort ranges by start
    std.mem.sort(Range, ranges.items, {}, rangeComparison);

    var ids = std.ArrayList(u64).empty;
    defer ids.deinit(allocator);
    while (lines.next()) |line| {
        const id = try std.fmt.parseInt(u64, line, 10);
        try ids.append(allocator, id);
    }

    var part_1: u64 = 0;
    for (ids.items) |id| {
        if (covered(id, ranges.items)) {
            part_1 += 1;
        }
    }
    std.debug.print("Part 1: {d}\n", .{part_1});

    var merged_ranges = std.ArrayList(Range).empty;
    defer merged_ranges.deinit(allocator);

    while (ranges.items.len > 0) {
        const current = ranges.items[0];
        const next_start = current.start;
        var next_end = current.end;
        ranges.items = ranges.items[1..];

        while (ranges.items.len > 0 and ranges.items[0].start <= next_end + 1) {
            next_end = @max(next_end, ranges.items[0].end);
            ranges.items = ranges.items[1..];
        }
        try merged_ranges.append(allocator, Range{ .start = next_start, .end = next_end });
    }
    var part_2: u64 = 0;
    for (merged_ranges.items) |range| {
        part_2 += range.end - range.start + 1;
    }
    std.debug.print("Part 2: {d}\n", .{part_2});
}
