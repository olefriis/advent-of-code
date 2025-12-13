const std = @import("std");

fn isInvalid1(id: []const u8) bool {
    return id.len % 2 == 0 and
        std.mem.eql(u8, id[0 .. id.len / 2], id[id.len / 2 ..]);
}

fn isInvalid2(id: []const u8) bool {
    if (id.len < 2) return false;

    outer: for (1..(id.len / 2 + 1)) |chunkSize| {
        if (id.len % chunkSize != 0) {
            continue :outer;
        }
        for (1..(id.len / chunkSize)) |chunkNumber| {
            for (0..chunkSize) |chunkIndex| {
                if (id[chunkIndex] != id[chunkIndex + chunkNumber * chunkSize]) {
                    continue :outer;
                }
            }
        }
        return true;
    }
    return false;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read the input file
    const file = try std.fs.cwd().openFile("02/input", .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    const bytes_read = try file.read(buffer);
    const content = buffer[0..bytes_read];

    // Trim whitespace from the input
    const line = std.mem.trim(u8, content, " \n\r\t");

    var part_1: u64 = 0;
    var part_2: u64 = 0;

    // Parse comma-separated ranges
    var ranges = std.mem.splitScalar(u8, line, ',');
    while (ranges.next()) |range| {
        // Parse "start-end" format
        var parts = std.mem.splitScalar(u8, range, '-');
        const start_str = parts.next() orelse continue;
        const end_str = parts.next() orelse continue;

        const start = try std.fmt.parseInt(u64, start_str, 10);
        const end = try std.fmt.parseInt(u64, end_str, 10);

        // Check each id in the range
        var id = start;
        while (id <= end) : (id += 1) {
            // Convert id to string
            var id_buffer: [20]u8 = undefined;
            const id_str = try std.fmt.bufPrint(&id_buffer, "{d}", .{id});

            if (isInvalid1(id_str)) {
                part_1 += id;
            }
            if (isInvalid2(id_str)) {
                part_2 += id;
            }
        }
    }

    std.debug.print("Part 1: {d}\n", .{part_1});
    std.debug.print("Part 2: {d}\n", .{part_2});
}
