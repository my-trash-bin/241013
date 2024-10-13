const std = @import("std");
const httpz = @import("httpz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var app = App{};

    var server = try httpz.Server(*App).init(allocator, .{ .port = 5882 }, &app);
    var router = server.router(.{});
    router.get("/api/user/:id", getUser, .{});
    try server.listen();
}

const App = struct {};

fn getUser(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    _ = app;

    const user_id = req.param("id").?;

    try res.json(.{
        .id = user_id,
        .name = user_id,
    }, .{});
}
