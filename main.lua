-- Create a new server
local server = Astra.http.server:new()

-- Register a route
server:get("/", function()
    return "hello from default Astra instance!"
end)

-- Configure the server
server.port = 3000

local db = Astra.database_connect('sqlite', 'posts.db')
db:execute([[
    CREATE TABLE IF NOT EXISTS posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        timestamp INTEGER
    );
]], {});

-- Try manually insert one
-- db:execute([[
--     INSERT INTO posts (title, content, timestamp) VALUES ('test', 'content', 1);
-- ]], {});

server:get('/posts', function()
    local result = db:query_all('SELECT * FROM posts ORDER BY timestamp DESC', {})
    return result
end)


-- Run the server
server:run()