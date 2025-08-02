//! {[position][specifier]:[fill][alignment][width].[precision]}
//! Position: Inded of the argument
//! Specifier: type-dependent formatting option
//! Fill: single character used for padding
//! Alignment: One of three characters < ^ >; for left, middle and right alignment
//! Width: total width of the field (characters)
//! Precision: how many decimals a formatted number should have

const std = @import("std");
const bufPrint = std.fmt.bufPrint;
const expectEqualStrings = std.testing.expectEqualStrings;

test "position" {
    var b: [3]u8 = undefined;

    try expectEqualStrings("aab", try bufPrint(&b, "{0s}{0s}{1s}", .{ "a", "b" }));
}

test "fill, alignment, width" {
    var b: [6]u8 = undefined;

    try expectEqualStrings("hi!  ", try bufPrint(&b, "{s: <5}", .{"hi!"}));
    try expectEqualStrings("_hi!__", try bufPrint(&b, "{s:_^6}", .{"hi!"}));
    try expectEqualStrings("!hi!", try bufPrint(&b, "{s:!>4}", .{"hi!"}));
}

test "precision" {
    var b: [4]u8 = undefined;
    try expectEqualStrings("3.14", try bufPrint(&b, "{d:.2}", .{3.14159}));
}
