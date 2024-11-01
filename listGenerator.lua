local mainModule = require("mainMod")
mainModule.init(arg)

local separator = ","
local sortElementsArgument = "-s"
local lockListArgument = "-lock"

local outputFileDirectory = "output/"

local workFile = mainModule.getOutputFile()

print("Creador de listas, introduce 1 por 1 los elementos de la lista separados por \""..separator.."\".")

local input = io.read("l")

local elements = mainModule.stringSplit(input, separator)
local correctedElements = {}

for index, v in pairs(elements) do
    if not tonumber(v) then
        table.remove(elements, index)
    else
        table.insert(correctedElements, tonumber(v))
    end
end

if mainModule.checkForArgument(sortElementsArgument) then
    table.sort(correctedElements)
end

for index, v in pairs(correctedElements) do
    workFile:write(v.."\n")
end

workFile:close()

if mainModule.checkForArgument(lockListArgument) then
    local filePath = mainModule.getArgument("-l") or error("No existe ese archivo!")
    mainModule.lockList(filePath)
end