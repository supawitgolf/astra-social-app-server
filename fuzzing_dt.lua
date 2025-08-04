local function summary(logs, filename)
    local total = #logs
    local n_ok = 0
    local n_failed = 0
    local ok_table = {}
    local failed_table = {}
    for _, log in ipairs(logs) do
        local args_types_str = "[" .. table.concat(log.args_types, ", ") .. "]"
        if log.ok then
            n_ok = n_ok + 1
            if not ok_table[args_types_str] then ok_table[args_types_str] = 0 end
            ok_table[args_types_str] = ok_table[args_types_str] + 1
        else
            n_failed = n_failed + 1
            if not failed_table[args_types_str] then failed_table[args_types_str] = 0 end
            failed_table[args_types_str] = failed_table[args_types_str] + 1
        end
    end

    -- logging
    local log_txt = io.open(filename, 'w')

    log_txt:write('Test ' ..total .. ' times\n\n')
    log_txt:write('Pass ' .. n_ok .. ' times\n')
    for k, v in pairs(ok_table) do
        log_txt:write(k .. ' ' .. v .. '\n')
    end
    log_txt:write('\nFailed ' .. n_failed .. ' times\n')
    for k, v in pairs(failed_table) do
        log_txt:write(k .. ' ' .. v .. '\n')
    end

    print('Test ' ..total .. ' times')
    print('Pass ' .. n_ok .. ' times')
    print('Failed ' .. n_failed .. ' times')
    print('Details in ' .. filename .. '\n')
end

local function random_value()
    local cases = {
        function() return math.random(-10000, -1), 'neg-int' end, -- neg-int
        function() return 0, 'zero' end, -- zero
        function() return math.random(1, 12), 'pos-int-1-12' end, -- int 1 - 12 (month)
        function() return math.random(13, 24), 'pos-int-13-24' end, -- int 13 - 24 (hr)
        function() return math.random(25, 30), 'pos-int-25-30' end, -- int 25 - 30 (day)
        function() return math.random(31, 60), 'pos-int-31-60' end, -- int 31 - 60 (min/sec)
        function() return math.random(61, 10000), 'pos-int-61-10000' end, -- pos-int 
        function() return math.random(), 'float-small' end, -- float
        function() return math.random() * 1e6, 'float-big' end, -- float
        function() return nil, 'nil' end, -- nil
        function() return 'dog', 'str' end, -- string
        function() return {}, 'table' end, -- empty string
        function() return true, 'bool' end -- boolean
    }
    return cases[math.random(#cases)]()
end

local function fuzz_new_from(iterations)
    local logs = {}
    for i = 1, iterations do
        local args = {}
        local types = {}
        for _ = 1, 7 do
            local val, label = random_value()
            table.insert(args, val)
            table.insert(types, label)
        end
        local ok, err = pcall(function()
            local dt = Astra.datetime.new_from(table.unpack(args))
        end)
        local log = {
            ok = ok,
            args = args,
            args_types = types
        }
        table.insert(logs, log)
    end
    return logs
end

local function fuzz_new_utc_from(iterations)
    local logs = {}
    for i = 1, iterations do
        local args = {}
        local types = {}
        for _ = 1, 7 do
            local val, label = random_value()
            table.insert(args, val)
            table.insert(types, label)
        end
        local ok, err = pcall(function()
            local dt = Astra.datetime.new_utc_from(table.unpack(args))
        end)
        local log = {
            ok = ok,
            args = args,
            args_types = types
        }
        table.insert(logs, log)
    end
    return logs
end

local logs = fuzz_new_from(1000)
summary(logs, 'fuzz_summ_new_from.txt')

local logs = fuzz_new_utc_from(1000)
summary(logs, 'fuzz_summ_new_utc_from.txt')

local function fuzz_set_year(iterations)
    local logs = {}
    local dt = Astra.datetime.new()
    for i = 1, iterations do
        local arg, type = random_value()
        local ok, err = pcall(function() dt:set_year(arg) end)
        local log = { ok = ok, args_types = {type} }
        table.insert(logs, log)
    end
    return logs
end
local logs = fuzz_set_year(1000)
summary(logs, 'fuzz_summ_set_year.txt')

local function fuzz_set_month(iterations)
    local logs = {}
    local dt = Astra.datetime.new()
    for i = 1, iterations do
        local arg, type = random_value()
        local ok, err = pcall(function() dt:set_month(arg) end)
        local log = { ok = ok, args_types = {type} }
        table.insert(logs, log)
    end
    return logs
end
local logs = fuzz_set_month(1000)
summary(logs, 'fuzz_summ_set_month.txt')

local function fuzz_set_hour(iterations)
    local logs = {}
    local dt = Astra.datetime.new()
    for i = 1, iterations do
        local arg, type = random_value()
        local ok, err = pcall(function() dt:set_hour(arg) end)
        local log = { ok = ok, args_types = {type} }
        table.insert(logs, log)
    end
    return logs
end
local logs = fuzz_set_hour(1000)
summary(logs, 'fuzz_summ_set_hour.txt')

local function fuzz_set_minute(iterations)
    local logs = {}
    local dt = Astra.datetime.new()
    for i = 1, iterations do
        local arg, type = random_value()
        local ok, err = pcall(function() dt:set_minute(arg) end)
        local log = { ok = ok, args_types = {type} }
        table.insert(logs, log)
    end
    return logs
end
local logs = fuzz_set_minute(1000)
summary(logs, 'fuzz_summ_set_minute.txt')

local function fuzz_set_second(iterations)
    local logs = {}
    local dt = Astra.datetime.new()
    for i = 1, iterations do
        local arg, type = random_value()
        local ok, err = pcall(function() dt:set_second(arg) end)
        local log = { ok = ok, args_types = {type} }
        table.insert(logs, log)
    end
    return logs
end
local logs = fuzz_set_second(1000)
summary(logs, 'fuzz_summ_set_second.txt')

local function fuzz_set_millisecond(iterations)
    local logs = {}
    local dt = Astra.datetime.new()
    for i = 1, iterations do
        local arg, type = random_value()
        local ok, err = pcall(function() dt:set_millisecond(arg) end)
        local log = { ok = ok, args_types = {type} }
        table.insert(logs, log)
    end
    return logs
end
local logs = fuzz_set_millisecond(1000)
summary(logs, 'fuzz_summ_set_millisecond.txt')

local function fuzz_set_epoch_millisecond(iterations)
    local logs = {}
    local dt = Astra.datetime.new()
    for i = 1, iterations do
        local arg, type = random_value()
        local ok, err = pcall(function() dt:set_epoch_millisecond(arg) end)
        local log = { ok = ok, args_types = {type} }
        table.insert(logs, log)
    end
    return logs
end
local logs = fuzz_set_epoch_millisecond(1000)
summary(logs, 'fuzz_summ_set_epoch_millisecond.txt')