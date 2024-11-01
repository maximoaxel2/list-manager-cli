local mainModule = require("mainMod")
mainModule.init(arg)

local list = mainModule.getList()

local elements = mainModule.getListElements(list)

for index, v in pairs(elements) do
    elements[index] = tonumber(v)
end

local sum = 0

for i, num in pairs(elements) do
    sum = sum + num
end

print("Resultado : "..sum)

list:close()

return sum