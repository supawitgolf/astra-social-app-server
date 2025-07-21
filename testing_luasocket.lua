local lu = require('luaunit')
local http = require('socket.http')
local ltn12 = require('ltn12')
local json = require('dkjson')

TestGetPostAPI = {}
TestPostPostAPI = {}
TestUpdatePostAPI = {}
TestDelPostAPI = {}

--for those stt 200 cases 
local function get_one_valid_id()
    local response = {}
    local _, list_status = http.request{
        url = 'http://localhost:3000/posts',
        method = 'GET',
        sink = ltn12.sink.table(response)
    }
    local body = table.concat(response)
    local posts, _, err = json.decode(body)
    local latest_id = posts[1].id
    return latest_id
end

-- POST helper
local function http_post(payload)
    local payload = json.encode(payload)
    local response = {}
    local _, status_code, headers = http.request{
        url = 'http://localhost:3000/posts',
        method = 'POST',
        headers = {
            ['Content-Type'] = 'application/json',
        },
        source = ltn12.source.string(payload),
        sink = ltn12.sink.table(response),
    }

    local body = table.concat(response)
    local data = json.decode(body)
    return status_code, data
end

-- PUT helper
local function http_put(id, payload)
    local payload = json.encode(payload)
    local response = {}
    local _, status_code, headers = http.request{
        url = "http://localhost:3000/posts/" .. tostring(id),
        method = "PUT",
        headers = {
            ['Content-Type'] = 'application/json',
        },
        source = ltn12.source.string(payload),
        sink = ltn12.sink.table(response),
    }

    local body = table.concat(response)
    local data = json.decode(body)
    return status_code, data
end

-- 200: valid
function TestGetPostAPI:testGetAllPosts()
    local response = {}
    local _, status_code, headers = http.request{
        url = 'http://localhost:3000/posts',
        method = 'GET',
        sink = ltn12.sink.table(response)
    }

    local body = table.concat(response)
    local data = json.decode(body)

    lu.assertEquals(status_code, 200)
    lu.assertIsTable(data)
    -- test field type
    if #data > 0 then
        lu.assertIsString(data[1].author)
        lu.assertIsString(data[1].content)
        lu.assertIsNumber(data[1].timestamp)
    end
end

-- 200: valid
function TestPostPostAPI:testpostValidPost()
    local status, data = http_post({
        author = 'tester',
        title = 'test_ttl',
        content = 'test_content'
    })
    lu.assertEquals(status, 200)
    lu.assertEquals(data.status, 'created')
end

-- 400: missing field
function TestPostPostAPI:testpostMissingFieldPost()
    local status, data = http_post({
        author = 'tester',
        title = 'test_ttl'

    })
    lu.assertEquals(status, 400)
    lu.assertStrContains(data.error, 'Invalid input')
end

-- 400: 400: invalid schema
function TestPostPostAPI:testpostInvalidTypePost()
    local status, data = http_post({
        author = 123,
        content = 'test_content'
    })
    lu.assertEquals(status, 400)
    lu.assertStrContains(data.error, 'Invalid input')
end

-- 200: valid id
function TestGetPostAPI:testGetValidId()
    local id = get_one_valid_id()
    local response = {}
    local _, status_code, headers = http.request{
        url = 'http://localhost:3000/posts/' .. tostring(id), 
        method = 'GET',
        sink = ltn12.sink.table(response)
    }
    lu.assertEquals(status_code, 200)
end

-- 500: invalid id
function TestGetPostAPI:testGetInvalidId()
    local response = {}
    local _, status_code, headers = http.request{
        url = 'http://localhost:3000/posts/0', -- never exist
        method = 'GET',
        sink = ltn12.sink.table(response)
    }
    lu.assertEquals(status_code, 500)
end

-- 200: valid range
function TestGetPostAPI:testGetPostsInRange()
    local response = {}
    local _, status_code, headers = http.request{
        url = 'http://localhost:3000/posts/range?from=2025-01-01&to=2026-01-01', 
        method = 'GET',
        sink = ltn12.sink.table(response)
    }
    lu.assertEquals(status_code, 200)

    local body = table.concat(response)
    local data = json.decode(body)
    lu.assertIsTable(data)
    lu.assertNotEquals(#data, 0)
end

-- 200: still valid but no matches
function TestGetPostAPI:testGetRangePostsNoMatches()
    local response = {}
    local _, status_code, headers = http.request{
        url = 'http://localhost:3000/posts/range?from=2024-01-01&to=2025-01-01', 
        method = 'GET',
        sink = ltn12.sink.table(response)
    }

    lu.assertEquals(status_code, 200)

    local body = table.concat(response)
    local data = json.decode(body)
    lu.assertIsTable(data)
    lu.assertEquals(#data, 0)
end

-- 200: valid
function TestUpdatePostAPI:testValidUpdate()
    local id = get_one_valid_id()
    local status, data = http_put(id, {
        author = 'Edited',
        content = 'Updated content'
    })
    lu.assertEquals(status, 200)
    lu.assertEquals(data.status, 'updated')
    lu.assertEquals(data.id, id)
end

-- 400: invalid id
function TestUpdatePostAPI:testInvalidId()
    local id = 'a'
    local status, data = http_put(id, {
        author = 'Edited',
        content = 'Updated content'
    })
    lu.assertEquals(status, 400)
    lu.assertEquals(data.error, 'Invalid post ID')
end

-- 400: invalid schema
function TestUpdatePostAPI:tesUnexistPost()
    local id = get_one_valid_id()
    local status, data = http_put(id, {
        author = 123,
        content = 'Updated content'
    })
    lu.assertEquals(status, 400)
    lu.assertStrContains(data.error, 'Invalid input')
end

-- 404: unexisting post
function TestUpdatePostAPI:tesiUnexistPost()
    local id = 0 -- never exist
    local status, data = http_put(id, {
        author = 'Edited',
        content = 'Updated content'
    })
    lu.assertEquals(status, 404)
    lu.assertEquals(data.error, 'Post not found.')
end





-- 404: post doesn't exist
function TestDelPostAPI:testDelInvalidPost()
    local response = {}
    local _, status_code, headers = http.request{
        url = 'http://localhost:3000/posts/0',  -- never exist
        method = 'DELETE',
        sink = ltn12.sink.table(response)
    }
    lu.assertEquals(status_code, 404)

    local body = table.concat(response)
    local data = json.decode(body)
    lu.assertEquals(data.error, "Post not found.")
end

-- 400: invalid id (string)
function TestDelPostAPI:testInvalidId()
    local response = {}
    local _, status_code, headers = http.request{
        url = 'http://localhost:3000/posts/a',  -- never exist
        method = 'DELETE',
        sink = ltn12.sink.table(response)
    }
    lu.assertEquals(status_code, 400)

    local body = table.concat(response)
    local data = json.decode(body)
    lu.assertEquals(data.error, 'Invalid post ID')
end

-- 200: valid 
function TestDelPostAPI:testValidPost()
    local id = get_one_valid_id()
    local response = {}
    local _, status_code, headers = http.request{
        url = 'http://localhost:3000/posts/' .. tostring(id),
        method = 'DELETE',
        sink = ltn12.sink.table(response)
    }
    lu.assertEquals(status_code, 200)

    local body = table.concat(response)
    local data = json.decode(body)
    lu.assertEquals(data.status, 'deleted')
    lu.assertEquals(data.id, id)
end


os.exit(lu.LuaUnit.run())
