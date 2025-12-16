const std = @import("std");

const Point = struct {
    x: i32,
    y: i32,

    // Required for HashMap: compute hash
    pub fn hash(self: Point) u64 {
        var hasher = std.hash.Wyhash.init(0);
        std.hash.autoHash(&hasher, self.x);
        std.hash.autoHash(&hasher, self.y);
        return hasher.final();
    }

    // Required for HashMap: check equality
    pub fn eql(self: Point, other: Point) bool {
        return self.x == other.x and self.y == other.y;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read the input file
    const file = try std.fs.cwd().openFile("04/input", .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    const bytes_read = try file.read(buffer);
    const content = buffer[0..bytes_read];

    var paper_rolls = std.HashMap(Point, void, std.hash_map.AutoContext(Point), std.hash_map.default_max_load_percentage).init(allocator);
    defer paper_rolls.deinit();

    var y: i32 = 0;
    var lines = std.mem.splitScalar(u8, content, '\n');
    while (lines.next()) |line| {
        for (line, 0..) |c, x| {
            if (c == '@') {
                _ = try paper_rolls.put(Point{ .x = @intCast(x), .y = y }, {});
            }
        }
        y += 1;
    }

    var has_written_part_1 = false;
    var part_2: u32 = 0;
    while (true) {
        var accessible = std.HashMap(Point, void, std.hash_map.AutoContext(Point), std.hash_map.default_max_load_percentage).init(allocator);
        defer accessible.deinit();

        var it = paper_rolls.keyIterator();
        while (it.next()) |point| {
            // Check neighbors
            const neighbors = [_]Point{
                .{ .x = point.x - 1, .y = point.y - 1 },
                .{ .x = point.x, .y = point.y - 1 },
                .{ .x = point.x + 1, .y = point.y - 1 },
                .{ .x = point.x - 1, .y = point.y },
                .{ .x = point.x + 1, .y = point.y },
                .{ .x = point.x - 1, .y = point.y + 1 },
                .{ .x = point.x, .y = point.y + 1 },
                .{ .x = point.x + 1, .y = point.y + 1 },
            };

            var neighbor_paperrolls: i32 = 0;
            for (neighbors) |neighbor| {
                if (paper_rolls.contains(neighbor)) {
                    neighbor_paperrolls += 1;
                }
            }

            if (neighbor_paperrolls < 4) {
                _ = try accessible.put(Point{ .x = point.x, .y = point.y }, {});
            }
        }

        const accessible_count = accessible.count();
        if (!has_written_part_1) {
            std.debug.print("Part 1: {d}\n", .{accessible_count});
            has_written_part_1 = true;
        }
        part_2 += accessible_count;
        if (accessible_count == 0) {
            std.debug.print("Part 2: {d}\n", .{part_2});
            break;
        }

        // Remove accessible from paper_rolls
        var accessible_it = accessible.keyIterator();
        while (accessible_it.next()) |point| {
            _ = paper_rolls.remove(point.*);
        }
    }
}
