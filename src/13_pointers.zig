const expect = @import("std").testing.expect;

fn increment(num: *u8) void {
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try expect(x == 2);
}

test "naughty pointer" {
    var x: u16 = 5;
    x -= 5;
    var y: *u8 = @ptrFromInt(x);
    y = y;
}

test "const pointers" {
    var x: u8 = 1;
    const y = &x;
    y.* += 1;
}
