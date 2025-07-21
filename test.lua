-- the goal of this .lua is to test the database connection


-- -- connect to your db
-- local db = Astra.database_connect("sqlite", "posts.db")

-- -- You can execute queries to the database along with optional parameters
-- db:execute([[
--     CREATE TABLE IF NOT EXISTS test (id SERIAL PRIMARY KEY, name TEXT);
--     INSERT INTO test(name) VALUES ('Astra');
-- ]], {});

-- -- And finally query either one which returns a single result or
-- local result = db:query_one("SELECT * FROM test;", {});

-- pprint(result)
-- local dt = Astra.datetime.new_now()
-- print(dt:to_locale_datetime_string())
-- local dt = Astra.datetime.new_from(2025, 7, 8, 23, 59, 59.999)
-- print(dt:to_locale_datetime_string())

-- local dt_string = '2025-07-08'

-- local function text2timestamp(dt_str, eod)
--     local year, month, day = dt_str:match("(%d+)%-(%d+)%-(%d+)")
--     year = tonumber(year)
--     month = tonumber(month)
--     day = tonumber(day)
    
--     local dt
--     if eod == true then 
--         dt = Astra.datetime.new_from(year, month, month, 23, 59, 59.999)
--     else
--         dt = Astra.datetime.new_from(year, month, month, 0, 0, 0)
--     end
--     return dt:get_epoch_milliseconds()
-- end

-- local from = text2timestamp(dt_string)
-- local to = text2timestamp(dt_string, true)
-- print(from, to)

-- local response = Astra.http.request("http://localhost:3000/posts"):execute()
-- print(response:body():json()[1])


-- local function http_post(payload)
--     local response = Astra.http.request('http://localhost:3000/posts')
--         :set_method('POST')
--         :set_json(payload)
--         :execute()
--     print(response:body():json().error)
--     -- local status_code = response:status_code()
--     -- local data = response:body():json()

--     -- return status_code, data
-- end



-- http_post({})

-- local dt = Astra.datetime.new_now()
-- print(dt:to_datetime_string())
-- print(dt:to_date_string())

-- connect to your db
-- local db = Astra.database_connect("sqlite", "a.db")

-- -- You can execute queries to the database along with optional parameters
-- db:execute([[
--     CREATE TABLE IF NOT EXISTS test (id SERIAL PRIMARY KEY, name TEXT);

--     INSERT INTO TABLE test(name) VALUES ('Astra');
-- ]], {});

-- -- And finally query either one which returns a single result or
-- local result = db:query_one("SELECT * FROM test;", {});

-- -- query all from tables which returns an array as result
-- -- which also supports parameters for protection against SQL injection attacks
-- local name = "Tom"
-- local result = db:query_all("INSERT INTO test (name) VALUES ($1)", {name});

-- pprint(result)
