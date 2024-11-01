local mainModule = require("mainMod")
mainModule.init(arg)

local list = mainModule.getList()
local elements = mainModule.getListElements(list)
list:close()

local outputList = mainModule.getOutputFile()

table.sort(elements)

for index, v in pairs(elements) do
    outputList:write(v.."\n")
end

print(outputList:read("a"))

outputList:close()