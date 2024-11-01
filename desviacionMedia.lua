local mainModule = require("mainMod")
mainModule.init(arg)

local listFile = mainModule.getList()

local promedio = 0

local vars = mainModule.getListElements(listFile)
table.sort(vars)

local sum = 0
local numeroElementos = #vars

for _, value in pairs(vars) do
    sum = sum + value
end

promedio = sum / numeroElementos

local medSum = 0

for _, num in pairs(vars) do
    medSum = medSum + math.abs(num - promedio)
end

local desviacionMedia = medSum/numeroElementos

print("Desviacion Media : "..desviacionMedia)