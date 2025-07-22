local lust = require 'lust'
local describe, it, expect = lust.describe, lust.it, lust.expect

describe('NewDatetimeFullArgs', function()
    local dt = Astra.datetime.new(2025, 7, 8, 0, 24, 48, 241)
    it('get_year()', function()
        expect(dt:get_year()).to.equal(2025)
    end)

    it('get_month()', function()
        expect(dt:get_month()).to.equal(7)
    end)

    it('get_day()', function()
        expect(dt:get_day()).to.equal(8)
    end)

    it('get_weekday()', function()
        expect(dt:get_weekday()).to.equal(2)
    end)

    it('get_hour()', function()
        expect(dt:get_hour()).to.equal(0)
    end)

    it('get_minute()', function()
        expect(dt:get_minute()).to.equal(24)
    end)

    it('get_second()', function()
        expect(dt:get_second()).to.equal(48)
    end)

    it('get_millisecond()', function()
        expect(dt:get_millisecond()).to.equal(241)
    end)
end)

describe('NewDatetimeDefault', function()
    local dt = Astra.datetime.new(2025)
    it('get_year()', function()
        expect(dt:get_year()).to.equal(2025)
    end)

    it('get_month()', function()
        expect(dt:get_month()).to.equal(1)
    end)

    it('get_day()', function()
        expect(dt:get_day()).to.equal(1)
    end)

    it('get_weekday()', function()
        expect(dt:get_weekday()).to.equal(3)
    end)

    it('get_hour()', function()
        expect(dt:get_hour()).to.equal(0)
    end)

    it('get_minute()', function()
        expect(dt:get_minute()).to.equal(0)
    end)

    it('get_second()', function()
        expect(dt:get_second()).to.equal(0)
    end)

    it('get_millisecond()', function()
        expect(dt:get_millisecond()).to.equal(0)
    end)
end)

describe('NewDatetimeByStr', function()
    local dt = Astra.datetime.new("Tue, 1 Jul 2003 10:52:37 +0200")
    it('get_year()', function()
        expect(dt:get_year()).to.equal(2003)
    end)

    it('get_month()', function()
        expect(dt:get_month()).to.equal(7)
    end)

    it('get_day()', function()
        expect(dt:get_day()).to.equal(1)
    end)

    it('get_weekday()', function()
        expect(dt:get_weekday()).to.equal(2)
    end)

    it('get_hour()', function()
        expect(dt:get_hour()).to.equal(10)
    end)

    it('get_minute()', function()
        expect(dt:get_minute()).to.equal(52)
    end)

    it('get_second()', function()
        expect(dt:get_second()).to.equal(37)
    end)

    it('get_millisecond()', function()
        expect(dt:get_millisecond()).to.equal(0)
    end)
end)

describe('Setters', function()
    local dt = Astra.datetime.new(2024)

    it('set_year()', function()
        dt:set_year(2025)
        expect(dt:get_year()).to.equal(2025)
    end)

    it('set_month()', function()
        dt:set_month(12)
        expect(dt:get_month()).to.equal(12)
    end)

    it('set_day()', function()
        dt:set_day(31)
        expect(dt:get_day()).to.equal(31)
    end)

    it('set_hour()', function()
        dt:set_hour(23)
        expect(dt:get_hour()).to.equal(23)
    end)

    it('set_minute()', function()
        dt:set_minute(59)
        expect(dt:get_minute()).to.equal(59)
    end)

    it('set_second()', function()
        dt:set_second(58)
        expect(dt:get_second()).to.equal(58)
    end)

    it('set_millisecond()', function()
        dt:set_millisecond(123)
        expect(dt:get_millisecond()).to.equal(123)
    end)
end)

describe('ToString', function()
    local dt = Astra.datetime.new(2020, 12, 25, 10, 30, 45, 500)
    it('to_date_string()', function()
        expect(dt:to_date_string()).to.equal('Fri Dec 25 2020')
    end)

    it('to_time_string()', function()
        expect(dt:to_time_string()).to.equal('10:30:45 -06:00-0600')
    end)

    it('to_datetime_string()', function()
        expect(dt:to_datetime_string()).to.equal('Fri Dec 25 2020 10:30:45 -06:00-0600')
    end)

    it('to_iso_string()', function()
        expect(dt:to_iso_string()).to.equal('2020-12-25T10:30:45.500-06:00')
    end)

    it('to_locale_date_string()', function()
        expect(dt:to_locale_date_string()).to.equal('12/25/20')
    end)

    it('to_locale_time_string()', function()
        expect(dt:to_locale_time_string()).to.equal('10:30:45')
    end)

    it('to_locale_datetime_string()', function()
        expect(dt:to_locale_datetime_string()).to.equal('Fri Dec 25 10:30:45 2020')
    end)
end)

describe('EpochMillisecond', function()
    local dt = Astra.datetime.new(1970)

    it('get_epoch_milliseconds()', function()
        expect(dt:get_epoch_milliseconds()).to.equal(21600000)
    end)
    
    it('set_epoch_milliseconds()', function()
        dt:set_epoch_milliseconds(21700100 + 2678400000) -- one month (ish)
        expect(dt:get_epoch_milliseconds()).to.equal(2700100100)
        expect(dt:to_locale_date_string()).to.equal('02/01/70')
    end)
end)

