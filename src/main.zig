const std = @import("std");
const Lexer = @import("lexer.zig");
const Parser = @import("parser.zig");
const Runtime = @import("runtime.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const source =
        \\DISPLAY 123
        \\DISPLAY HELLO
    ;

    const tokens = try Lexer.tokenize(allocator, source);
    const program = try Parser.parseProgram(allocator, tokens);

    Runtime.exec(program);
}
