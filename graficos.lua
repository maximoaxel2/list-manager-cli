local mainModule = require("mainMod")
mainModule.init(arg)

---Checks if x is between a and b
---@param x number
---@param a number
---@param b number
local function insideOfRange(x, a, b)
    if (x <= b) and (x >= b) then
        return true
    end
    return false
end

local listFile = mainModule.getList()
local listElements = mainModule.getListElements(listFile)
listFile:close()

local min = math.min(table.unpack(listElements))
local max = math.max(table.unpack(listElements))
local range = max - min
local interval = mainModule.round(math.sqrt(range))
local amplitud = range / interval

local graphTable = {}

for i = 1, interval do
    graphTable[i] = {}
end