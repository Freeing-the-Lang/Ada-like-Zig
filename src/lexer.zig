const std = @import("std");

pub const TokenKind = enum {
    Number,
    Ident,
    LParen,
    RParen,
    Comma,
    EOF,
};

pub const Token = struct {
    kind: TokenKind,
    text: []const u8,
};

pub fn tokenize(allocator: *std.mem.Allocator, src: []const u8) ![]Token {
    var list = std.ArrayList(Token).init(allocator);
    var i: usize = 0;

    while (i < src.len) {
        const c = src[i];

        if (std.ascii.isDigit(c)) {
            var start = i;
            while (i < src.len and std.ascii.isDigit(src[i])) : (i += 1) {}
            try list.append(.{
                .kind = .Number,
                .text = src[start..i],
            });
            continue;
        }

        if (std.ascii.isAlphabetic(c)) {
            var start = i;
            while (i < src.len and std.ascii.isAlphabetic(src[i])) : (i += 1) {}
            try list.append(.{
                .kind = .Ident,
                .text = src[start..i],
            });
            continue;
        }

        switch (c) {
            '(' => try list.append(.{ .kind = .LParen, .text = "(" }),
            ')' => try list.append(.{ .kind = .RParen, .text = ")" }),
            ',' => try list.append(.{ .kind = .Comma,  .text = "," }),
            ' ', '\n', '\t' => {},
            else => {},
        }

        i += 1;
    }

    try list.append(.{ .kind = .EOF, .text = "" });
    return list.toOwnedSlice();
}
