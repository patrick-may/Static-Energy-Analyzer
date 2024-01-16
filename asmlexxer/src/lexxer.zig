const std = @import("std");

const AsmState = enum {
    label,
    mnemonic,
    operand,
    comment,
    eof,
};

// cycle through possible token states
pub fn nextState(curr_state: AsmState) AsmState {
    switch (curr_state) {
        .label => return .mnemonic,
        .mnemonic => return .operand,
        .operand => return .comment,
        .comment => return .label,

        .eof => return .eof,
    }
}

const Token = union(enum) {
    // different types of asm tokens
    label: []const u8,
    mnemonic: []const u8,
    operand: []const u8,
    comment: []const u8,
    eof: u8,

    fn whatis(ident: []const u8) ?Token {
        const translate =
            std.ComptimeStringMap(Token, .{ .{ "label", .label }, .{ "mnemonic", .mnemonic }, .{ "operand", .operand }, .{ "comment", .comment }, .{ "eof", .eof } });

        return translate.get(ident);
    }
};

pub const Lexxer = struct {
    const Self = @This();

    read_pos: usize = 0,
    position: usize = 0,
    curr_ch: u8 = 0,
    // additional state we get because parsing ASM
    asmstate: AsmState = .label,

    input: []const u8, // str

    pub fn init(input: []const u8) Self {
        var lex = Self{
            .input = input,
        };

        lex.read_char();

        return lex;
    }

    pub fn has_tokens(self: *Self) bool {
        return self.curr_ch != 0;
    }

    pub fn next_token(self: *Self) Token {
        self.skip_whitespace(); // updates state as needed

        const curr_tok: Token = switch (self.asmstate) {
            .label => .{ .label = self.read_label() },
            .mnemonic => .{ .mnemonic = self.read_mnemonic() },
            .operand => .{ .operand = self.read_operand() },
            .comment => .{ .comment = self.read_comment() },
            .eof => .{ .eof = 0 },
        };
        return curr_tok;
    }

    fn read_label(self: *Self) []const u8 {
        const start_label = self.position;

        while ((std.ascii.isAlphanumeric(self.curr_ch) or self.curr_ch == ':' or self.curr_ch == '.') and self.asmstate != .eof) {
            self.read_char();
        }
        // mutate state to be expecting cpu pseudoop or mnemonic next
        //self.asmstate = nextState(self.asmstate);
        // return slice up to end of label
        return self.input[start_label..self.position];
    }

    fn read_mnemonic(self: *Self) []const u8 {
        const start_oper: usize = self.position;

        while (!std.ascii.isWhitespace(self.curr_ch) and self.asmstate != .eof) {
            self.read_char();
        }

        //self.asmstate = nextState(self.asmstate);
        return self.input[start_oper..self.position];
    }

    fn read_comment(self: *Self) []const u8 {
        const start_comment: usize = self.position;
        // go until end-of-line
        while (self.curr_ch != '\n') {
            self.read_char();
        }

        //self.asmstate = nextState(self.asmstate);
        return self.input[start_comment..self.position];
    }

    fn read_operand(self: *Self) []const u8 {
        const start_oprnd: usize = self.position;
        var moreops: bool = false;

        while ((self.curr_ch != ',') and self.curr_ch != '\n' and self.curr_ch != '\t' and self.asmstate != .eof) {
            self.read_char();
            if (self.curr_ch == '[') {
                std.debug.print("Brace mode activated \n", .{});
            }
            if (self.curr_ch == ',') {
                moreops = true;
                break;
            }
        }

        return self.input[start_oprnd..self.position];
    }

    fn read_char(self: *Self) void {
        if (self.read_pos >= self.input.len) { // beyond input length
            self.curr_ch = 0;
            self.asmstate = .eof;
        } else { // otherwise normal
            self.curr_ch = self.input[self.read_pos];
        }
        // look ahead 1
        self.position = self.read_pos;
        self.read_pos += 1;
    }

    fn skip_whitespace(self: *Self) void {
        while (std.ascii.isWhitespace(self.curr_ch) or self.curr_ch == ',') {
            // if newline, reset expected state
            if (self.curr_ch == '\n') {
                self.asmstate = AsmState.label;
            } else if (self.curr_ch == '\t') {
                self.asmstate = nextState(self.asmstate);
            }
            self.read_char();
        }
    }
};

pub fn main() !void {
    std.debug.print("Lexxer Testing\n", .{});

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    // arena alloc API
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const filename = "../TestPrograms/puts.s";
    //const file_contents = @embedFile(filename);

    const file_contents = try std.fs.cwd().readFileAlloc(allocator, filename, std.math.maxInt(usize));
    std.debug.print("{s}\n", .{file_contents});

    var myLexxer = Lexxer.init(file_contents);
    var foundTok: Token = myLexxer.next_token();
    while (foundTok != Token.eof) : (foundTok = myLexxer.next_token()) {

        // cool print statement stuff
        try stdout.print("{s}\t{s}\n", switch (foundTok) {
            .comment => .{ "Comm", foundTok.comment },
            .mnemonic => .{ "Mnem", foundTok.mnemonic },
            .operand => .{ "Oper", foundTok.operand },
            .label => .{ "Label", foundTok.label },
            .eof => .{ "EOF", "0" },
        });
        //try stdout.print("{c}\n", .{myLexxer.curr_ch});
    }

    try bw.flush(); // don't forget to flush!
}

pub fn lexxFile(filestr: []const u8) !std.ArrayList {
    std.debug.print("Parsing File: {s}\n", .{filestr});

    // arena alloc API
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    //const file_contents = @embedFile(filename);
    const file_contents = try std.fs.cwd().readFileAlloc(allocator, filestr, std.math.maxInt(usize));
    //std.debug.print("{s}\n", .{file_contents});

    var myLexxer = Lexxer.init(file_contents);
    var foundTok: Token = myLexxer.next_token();

    var parseStream: std.ArrayList = std.ArrayList(Token).init(allocator);
    while (foundTok != Token.eof) : (foundTok = myLexxer.next_token()) {
        try parseStream.append(foundTok);
        //try stdout.print("{c}\n", .{myLexxer.curr_ch});
    }

    return parseStream;
}
const testing = std.testing;

test "token constructors" {
    std.debug.print("\nToken Functionality\n", .{});

    const t1: Token = .{ .label = "this is a label" };
    const t2: Token = .{ .mnemonic = "this is a mnemonic" };
    const t3: Token = .{ .operand = "this is a operand" };
    const t4: Token = .{ .comment = "this is a comment" };

    std.debug.print("Label: {s}\nMnem: {s}\nOperand: {s}\nComment: {s}\n", .{ t1.label, t2.mnemonic, t3.operand, t4.comment });
}
// test cyclic feature
test "asm cycle" {
    std.debug.print("\n", .{});

    var my_state: AsmState = .label;

    inline for (1..6) |i| {
        std.debug.print("Idx: {} AsmState: {}\n", .{ i, my_state });
        switch (i) {
            1 => try testing.expectEqual(AsmState.label, my_state),
            2 => try testing.expectEqual(AsmState.mnemonic, my_state),
            3 => try testing.expectEqual(AsmState.operand, my_state),
            4 => try testing.expectEqual(AsmState.comment, my_state),
            5 => try testing.expectEqual(AsmState.label, my_state),
            else => unreachable,
        }

        my_state = nextState(my_state);
    }
}

// test label parsing
test "lexxer labels" {
    std.debug.print("\n", .{});
    const label_test =
        \\LFE0: 
        \\LFB1:
    ;

    var lex = Lexxer.init(label_test);

    var expected_toks = [_]Token{
        .{ .label = "LFE0:" },
        .{ .label = "LFB1:" },
    };

    for (expected_toks) |expected_tok| {
        const actual_tok = lex.next_token();
        std.debug.print("Expecting: {s}\t Actual: {s}\n", .{ expected_tok.label, actual_tok.label });
        try testing.expectEqualDeep(expected_tok, actual_tok);
    }
}

// test label parsing
test "lexxer mnems" {
    std.debug.print("\n", .{});
    const label_ops_test = "LFE0:\tbwi\nLFB1:\tret";

    var lex = Lexxer.init(label_ops_test);

    var expected_toks = [_]Token{
        .{ .label = "LFE0:" },
        .{ .mnemonic = "bwi" },
        .{ .label = "LFB1:" },
        .{ .mnemonic = "ret" },
    };

    for (expected_toks) |expected_tok| {
        const actual_tok = lex.next_token();
        std.debug.print("Expecting: {}\t Actual: {}\n", .{ expected_tok, actual_tok });
        try testing.expectEqualDeep(expected_tok, actual_tok);
    }
}

test "lexxer operands" {
    std.debug.print("\n", .{});
    const label_ops_test = "LFE0:\tbwi\trf\nLFB1:\tret\tsp, 0\n\tmov\tw0, 1";

    var lex = Lexxer.init(label_ops_test);

    var expected_toks = [_]Token{
        .{ .label = "LFE0:" },
        .{ .mnemonic = "bwi" },
        .{ .operand = "rf" },
        .{ .label = "LFB1:" },
        .{ .mnemonic = "ret" },
        .{ .operand = "sp" },
        .{ .operand = "0" },
        .{ .mnemonic = "mov" },
        .{ .operand = "w0" },
        .{ .operand = "1" },
    };

    for (expected_toks) |expected_tok| {
        const actual_tok = lex.next_token();
        std.debug.print("Expecting: {}\t Actual: {}\n", .{ expected_tok, actual_tok });
        try testing.expectEqualDeep(expected_tok, actual_tok);
    }
}
