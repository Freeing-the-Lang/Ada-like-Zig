const std = @import("std");
const AST = @import("ast.zig");

pub fn exec(program: AST.Program) void {
    for (program.stmts) |stmt| {
        switch (stmt.kind) {
            .Display => {
                printExpr(stmt.expr);
            },
            .Call => {
                // call 은 아직 미구현
                std.debug.print("[call ignored]\n", .{});
            },
        }
    }
}

fn printExpr(expr: AST.Expr) void {
    switch (expr.kind) {
        .Number => std.debug.print("{}\n", .{expr.value.?}),
        .Ident  => std.debug.print("{}\n", .{expr.name.?}),
        else    => std.debug.print("[complex expr]\n", .{}),
    }
}
