local mainModule = require("mainMod")
mainModule.init(arg)

local listFile = mainModule.getList()
local listElements = mainModule.getListElements(listFile)

listFile:close()

local sum = 0
for i, x in pairs(listElements) do
    sum = sum + x
end
local prom = sum/#listElements
print("Promedio : "..prom)
return prom