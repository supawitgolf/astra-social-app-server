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
        author TEXT NOT NULL,
        title TEXT,
        content TEXT NOT NULL,
        timestamp INTEGER
    );
]], {});

-- Try manually insert one
-- db:execute([[
--     INSERT INTO posts (title, content, timestamp) VALUES ('test', 'content', 1);
-- ]], {});

server:get('/posts', function(_, res)
    local ok, result = pcall(function()
        return db:query_all('SELECT * FROM posts ORDER BY timestamp DESC', {})
    end)

    if not ok then
        res:set_status_code(500)
        return { error = 'Failed to fetch posts.' }
    end

    res:set_header('Content-Type', 'application/json')
    return result
end)

server:post('/posts', function(req, res)
    local data = req:body():json()

    -- validate input format
    local schema = {
        author = { type = 'string' },
        title = { type = 'string', required = false },
        content = { type = 'string' },
    }
    local is_valid, err = Astra.validate_table(data, schema)
    if not is_valid then
        res:set_status_code(400)
        return { error = 'Invalid input: ' .. tostring(err) }
    end

    local timestamp = Astra.datetime.new_now():get_epoch_milliseconds()
    db:execute([[
        INSERT INTO posts (author, title, content, timestamp)
        VALUES ($1, $2, $3, $4);
    ]], { data.author, data.title, data.content, timestamp });

    res:set_status_code(200)
    res:set_header('Content-Type', 'application/json')
    return { status = 'created' }

end)

server:put('/posts/{id}', function(req, res)
    local uri = req:uri()
    local id = tonumber(string.match(uri, '^/posts/(%d+)$'))
    -- local id = tonumber(req:params('id'))
    -- print(uri, id)
    if not id then
        res:set_status_code(400)
        return { error = 'Invalid post ID' }
    end

    local data = req:body():json()

    -- title must stay the same & author must concat w existing authors ex. name1, name2, ...
    local schema = {
        author = { type = 'string' },
        content = { type = 'string' },
    }

    local is_valid, err = Astra.validate_table(data, schema)
    if not is_valid then
        res:set_status_code(400)
        return { error = 'Invalid input: ' .. tostring(err) }
    end

    -- check popst existence
    local ok, post = pcall(function()
        return db:query_one('SELECT 1 FROM posts WHERE id = $1', {id})
    end)
    
    if not ok or not post then
        res:set_status_code(404)
        return { error = 'Post not found.' }
    end

    local ok, _ = pcall(function()
        return db:execute([[
            UPDATE posts
            SET 
                author = author || $1,
                content = $2
            WHERE id = $3
        ]], {', ' .. data.author, data.content, id})
    end)
    
    if not ok then
        res:set_status_code(500)
        return { error = 'Failed to update post.' }
    end

    res:set_status_code(200)
    res:set_header('Content-Type', 'application/json')
    return { status = 'updated', id = id }
end)





-- Run the server
server:run()
