local mainModule = require("mainMod")
mainModule.init(arg)

local listFile = mainModule.getList()

local promedio = 0
local mediana = 0
local moda = {}

local vars = mainModule.getListElements(listFile)
table.sort(vars)

local sum = 0
local numeroElementos = #vars


for index, value in pairs(vars) do
    sum = sum + value
end

promedio = sum / numeroElementos

local repeatTable = {}

for index, value in pairs(vars) do
    if not repeatTable[value] then
        repeatTable[value] = 0
    end

    repeatTable[value] = repeatTable[value] + 1
end

local biggest = nil

for i, v in pairs(repeatTable) do
    if not biggest then
        biggest = i
    end

    if v > repeatTable[biggest] then
        biggest = i
    end
end

for i, v in pairs(repeatTable) do
    if v == repeatTable[biggest] then
        table.insert(moda, i)
    end
end

if repeatTable[biggest]  == 1 then
    moda = {"Ninguno"}
end

local elementoCentral = (numeroElementos + 1) / 2

if elementoCentral == math.floor(elementoCentral) then
    mediana = vars[elementoCentral]
else
    mediana = (vars[elementoCentral-0.5]+vars[elementoCentral+0.5]) /2
end

print("Media : ".. promedio)
print("Mediana : ".. mediana)
print("Moda : " .. table.concat(moda, ", "))