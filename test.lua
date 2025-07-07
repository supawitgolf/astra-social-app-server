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

local dt_string = '2025-07-08'

local function text2timestamp(dt_str, eod)
    local year, month, day = dt_str:match("(%d+)%-(%d+)%-(%d+)")
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)
    
    local dt
    if eod == true then 
        dt = Astra.datetime.new_from(year, month, month, 23, 59, 59.999)
    else
        dt = Astra.datetime.new_from(year, month, month, 0, 0, 0)
    end
    return dt:get_epoch_milliseconds()
end

local from = text2timestamp(dt_string)
local to = text2timestamp(dt_string, true)
print(from, to)