const std = @import("std");
const Lexer = @import("lexer.zig");
const AST = @import("ast.zig");

pub fn parseProgram(allocator: *std.mem.Allocator, tokens: []Lexer.Token) !AST.Program {
    var stmts = std.ArrayList(AST.Stmt).init(allocator);
    var pos: usize = 0;

    fn peek(tokens: []Lexer.Token, pos: usize) Lexer.Token {
        return tokens[pos];
    }

    fn advance(tokens: []Lexer.Token, pos: *usize) Lexer.Token {
        const t = tokens[pos.*];
        pos.* += 1;
        return t;
    }

    while (peek(tokens, pos).kind != .EOF) {
        const t = peek(tokens, pos);

        // DISPLAY expr
        if (t.kind == .Ident and std.mem.eql(u8, t.text, "DISPLAY")) {
            _ = advance(tokens, &pos);

            const expr = try parseExpr(allocator, tokens, &pos);

            try stmts.append(.{
                .kind = .Display,
                .expr = expr,
            });
        } else {
            const expr = try parseExpr(allocator, tokens, &pos);

            try stmts.append(.{
                .kind = .Call,
                .expr = expr,
            });
        }
    }

    return .{
        .stmts = try stmts.toOwnedSlice(),
    };
}

pub fn parseExpr(allocator: *std.mem.Allocator, tokens: []Lexer.Token, pos: *usize) !AST.Expr {
    const t = advance(tokens, pos);

    switch (t.kind) {
        .Number => return .{
            .kind = .Number,
            .value = t.text,
        },
        .Ident => {
            var expr = AST.Expr{
                .kind = .Ident,
                .name = t.text,
            };

            if (peek(tokens, pos.*).kind == .LParen) {
                _ = advance(tokens, pos); // '('

                var args = std.ArrayList(AST.Expr).init(allocator);

                while (peek(tokens, pos.*).kind != .RParen) {
                    const arg = try parseExpr(allocator, tokens, pos);
                    try args.append(arg);

                    if (peek(tokens, pos.*).kind != .Comma) break;
                    _ = advance(tokens, pos);
                }

                _ = advance(tokens, pos); // ')'

                expr.kind = .Call;
                expr.args = try args.toOwnedSlice();
            }

            return expr;
        },
        else => return AST.Expr{ .kind = .Ident, .name = "" },
    }
}
