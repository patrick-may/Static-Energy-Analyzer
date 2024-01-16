// 'main' for full pipeline of processing
const std = @import("std");
const lexxer = @import("lexxer.zig");

fn pairArgs(allocator: std.heap.Allocator, args: [][:0]u8) !std.HashMap {
    var parseMap = std.StringHashMap([]u8).init(allocator);
    _ = parseMap;
    var idx: i32 = 0;
    while (idx < args.size() - 2) : (idx += 2) {
        std.debug.print("{} - {}", .{ args[idx], args[idx + 1] });
    }
}

pub fn main() !void {
    var mainAlloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer mainAlloc.deinit();

    var allocator: std.heap.Allocator = mainAlloc.allocator();
    var cmdArgs = try std.process.argsAlloc(allocator);

    std.debug.print("{s}", .{cmdArgs});
    pairArgs(allocator, cmdArgs);
    //for (cmdArgs) |arg| {
    //std.debug.print("{s}\n", .{arg});
    //}
}
