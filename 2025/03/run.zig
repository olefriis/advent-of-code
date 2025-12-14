const std = @import("std");

fn biggestJoltage(joltages_in: []const u8, number_of_batteries: usize) !u64 {
    if (number_of_batteries == 0) {
        return 0;
    }

    const biggestValidJoltage = std.mem.max(u8, joltages_in[0 .. joltages_in.len - number_of_batteries + 1]);
    const indexOfBiggestValidJoltage = std.mem.indexOf(u8, joltages_in, &.{biggestValidJoltage}) orelse
        return error.ValueNotFound;
    return @as(u64, biggestValidJoltage) * std.math.pow(u64, 10, @as(u64, number_of_batteries - 1)) +
        try biggestJoltage(joltages_in[indexOfBiggestValidJoltage + 1 ..], number_of_batteries - 1);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read the input file
    const file = try std.fs.cwd().openFile("03/input", .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    const bytes_read = try file.read(buffer);
    const content = buffer[0..bytes_read];

    var part_1: u64 = 0;
    var part_2: u64 = 0;

    // Process lines
    var lines = std.mem.splitScalar(u8, content, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        // Convert each character to a digit
        var joltages = try allocator.alloc(u8, line.len);
        defer allocator.free(joltages);

        for (line, 0..) |c, i| {
            joltages[i] = c - '0'; // Convert '0'-'9' to 0-9
        }

        part_1 += try biggestJoltage(joltages, 2);
        part_2 += try biggestJoltage(joltages, 12);
    }

    std.debug.print("Part 1: {d}\n", .{part_1});
    std.debug.print("Part 2: {d}\n", .{part_2});
}
