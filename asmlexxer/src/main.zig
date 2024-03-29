// 'main' for full pipeline of processing
const std = @import("std");
const lexxer = @import("lexxer.zig");

const Allocator = std.mem.Allocator;
const HashMap = std.StringHashMap;
const StringType = []const u8;

fn pairArgs(allocator: Allocator, args: []const StringType) HashMap(StringType) {
    var parseMap = std.StringHashMap(StringType).init(allocator);
    var idx: usize = 1;
    while (idx < args.len - 2) : (idx += 2) {
        try parseMap.put(args[idx], args[idx + 1]);
        std.debug.print("{s} - {s}", .{ args[idx], args[idx + 1] });
    }

    return parseMap;
}

pub fn main() !void {
    var mainAlloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer mainAlloc.deinit();

    var allocator = mainAlloc.allocator();
    var cmdArgs = try std.process.argsAlloc(allocator);

    std.debug.print("{s}", .{cmdArgs});
    if (cmdArgs.len < 2 or cmdArgs.len % 2 == 0) {
        std.debug.print("Incorrect args used", .{});
        return;
    }
    var argMap = pairArgs(allocator, cmdArgs);
    var argIter = argMap.iterator();
    while (argIter.next()) |entry| {
        std.debug.print("{any}", .{entry});
    }
    // for (a) |arg| {
    //     std.debug.print("{s}\n", .{arg});
    // }
}
