const std = @import("std");
const expect = @import("std").testing.expect;
const eql = std.mem.eql;

test "createFile, write, seekTo, read" {
    const file = try std.fs.cwd().createFile(
        "temp-files/junk_file.txt",
        .{ .read = true },
    );
    defer file.close();

    try file.writeAll("Hello File!");

    var buffer: [100]u8 = undefined;
    try file.seekTo(0);
    const bytes_read = try file.readAll(&buffer);

    try expect(eql(u8, buffer[0..bytes_read], "Hello File!"));
}

test "file stat" {
    const file = try std.fs.cwd().createFile("temp-files/junk_file2.txt", .{ .read = true });
    defer file.close();
    const stat = try file.stat();
    try expect(stat.size == 0);
    try expect(stat.kind == .file);
    try expect(stat.ctime <= std.time.nanoTimestamp());
    try expect(stat.mtime <= std.time.nanoTimestamp());
    try expect(stat.atime <= std.time.nanoTimestamp());
}

test "make dir" {
    try std.fs.cwd().makeDir("temp-files/test-tmp");
    var root_dir = try std.fs.cwd().openDir("temp-files", .{ .iterate = true });
    var iter_dir = try root_dir.openDir(
        "test-tmp",
        .{ .iterate = true },
    );
    defer {
        iter_dir.close();
        root_dir.deleteTree("test-tmp") catch unreachable;
        root_dir.close();
    }

    _ = try iter_dir.createFile("x", .{});
    _ = try iter_dir.createFile("y", .{});
    _ = try iter_dir.createFile("z", .{});

    var file_count: usize = 0;
    var iter = iter_dir.iterate();
    while (try iter.next()) |entry| {
        if (entry.kind == .file) file_count += 1;
    }

    try expect(file_count == 3);
}
