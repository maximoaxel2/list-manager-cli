local mainModule = require("mainMod")
mainModule.init(arg)

local listFile = mainModule.getList()
local elements = mainModule.getListElements(listFile)
listFile:close()

table.sort(elements)

local input = mainModule.getArgument("-e")
if not input then
    error("No se brindo el indice del elemento deseado!")
end
local strNums = mainModule.stringSplit(input, "/")
local num1 = tonumber(strNums[1])
local num2 = tonumber(strNums[2])
local index = 0
if not num1 then
    error("No se brindo un indice valido!")
end

if not num2 then
    num2 = 1
end

index = num1/num2

if index > 1 then
    index = 1
end

if index < 0 then
    index = 0
end

index = index * #elements

local indexFloor = math.floor(index)
local indexCeil = math.ceil(index)

local difference = elements[indexCeil] - elements[indexFloor]
local interval = indexCeil - index

local result = (difference * interval) + elements[indexFloor]

print(result)