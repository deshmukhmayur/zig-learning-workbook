const Window = opaque {};
const Button = opaque {};

extern fn show_window(*Window) callconv(.C) void;

test "opaque" {
    const main_window: *Window = undefined;
    show_window(main_window);

    const ok_button: *Button = undefined;
    show_window(ok_button);
}

const Window2 = opaque {
    fn show(self: *Window2) void {
        show_window2(self);
    }
};

extern fn show_window2(*Window2) callconv(.C) void;

test "opaque with declarations" {
    const main_window: *Window2 = undefined;
    main_window.show();
}
