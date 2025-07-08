local env = 'test' -- 'test' or 'prod'

local db_file_map = {
    test = "posts_test.db",
    prod = "posts.db",
}

return {
    env = env,
    db_file = db_file_map[env]
}