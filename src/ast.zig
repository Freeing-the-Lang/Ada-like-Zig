pub const ExprKind = enum {
    Number,
    Ident,
    Call,
};

pub const Expr = struct {
    kind: ExprKind,
    value: ?[]const u8 = null,
    name: ?[]const u8 = null,
    args: []Expr = &[_]Expr{},
};

pub const StmtKind = enum {
    Display,
    Call,
};

pub const Stmt = struct {
    kind: StmtKind,
    expr: Expr,
};

pub const Program = struct {
    stmts: []Stmt,
};
