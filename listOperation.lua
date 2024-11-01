local mainModule = require("mainMod")
mainModule.init(arg)

local listFile = mainModule.getList()
local altListFile = mainModule.getAltList()

local sum = 0
local listElements = mainModule.getListElements(listFile)
local altListElements = mainModule.getListElements(altListFile)

for i, x in pairs(listElements) do
    sum = sum + x
end
local prom = sum / #listElements

local localEnv = {
    math = math,
    table = table,

    list = listElements,
    altList = altListElements,
    pairs = pairs,

    prom = prom,
    sum = sum,
    n = #listElements,

    reg = {}
}

local str = "local oL = {}\nfor i, x in pairs(list) do\n"
local str2 = "\nend\nreturn oL"

print("Usa oL[i] para escribir en el elemento actual, el elemento actual es representado por la x.")
print("Estan disponibles las siguientes variables : ")
print("prom - Promedio de la lista; sum - Sumatoria de la lista; n - Numero de elementos de la lista.")
print("Tambien estan disponibles todas las funciones math de lua : ")

local outputList = load(str .. io.read() .. str2, nil, nil, localEnv)()

listFile:close()

local workFile = mainModule.getOutputFile()

for index, v in pairs(outputList) do
    workFile:write(v .. "\n")
end

workFile:close()
