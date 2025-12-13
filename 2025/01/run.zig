const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read the input file
    const file = try std.fs.cwd().openFile("01/input", .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    const bytes_read = try file.read(buffer);
    const content = buffer[0..bytes_read];

    var dial: i32 = 50;
    var part_1: i32 = 0;
    var part_2: i32 = 0;

    // Process lines
    var lines = std.mem.splitScalar(u8, content, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const direction = line[0];
        const amount = try std.fmt.parseInt(i32, line[1..], 10);

        switch (direction) {
            'R' => {
                dial += amount;
                part_2 += @divFloor(dial, 100);
                dial = @mod(dial, 100);
            },
            'L' => {
                const was_zero = dial == 0;
                dial -= amount;

                part_2 -= @divFloor(dial, 100);
                dial = @mod(dial, 100);
                if (was_zero) part_2 -= 1; // Don't count previous 0 twice
                if (dial == 0) part_2 += 1; // ...but count if we end up at 0
            },
            else => {
                std.debug.print("Unknown direction: {c}\n", .{direction});
                return error.UnknownDirection;
            },
        }

        if (dial == 0) part_1 += 1;
    }

    std.debug.print("Part 1: {d}\n", .{part_1});
    std.debug.print("Part 2: {d}\n", .{part_2});
}
