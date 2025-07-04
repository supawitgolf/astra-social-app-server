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
local dt = Astra.datetime.new_utc_now()
print(type(dt:to_datetime_string()))