local _LOCKED_STRING = "<!!! LIST LOCKED !!!>" -- A default string thats present in the first line of locked lists

local module = {}
module.argumentList = nil

local function assertInit()
    if not module.argumentList then
        error("No se inicializo el modulo principal!")
    end
end


---Splits a string using a given separator
---@param inputstr string
---@param sep string
---@return table
function module.stringSplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

---Rounds x
---@param x number
---@return number
function module.round(x)
    local xFloor = math.floor(x)
    local xCeil = math.ceil(x)
    local floorDiff = x - xFloor
    local ceilDiff = x - xCeil

    if floorDiff > ceilDiff then
        return xCeil
    elseif floorDiff < ceilDiff then 
        return xFloor
    else
        return xCeil
    end
end

---ask the user to answer a prompt.
---@param msg string the message to be show to the user
---@param options table<string> a table of options to show the user.
---@return string | number -- the index of the option selected
function module.promptUser(msg, options)
    io.write(msg .. "\n")

    for index, value in pairs(options) do
        io.write("[" .. index .. "] : " .. value .. " | ")
    end

    io.write("Elige una opcion : ")

    local input = io.read("l")

    input = tonumber(input) or input or options[1]

    local selectedOption = options[input]
    local result = input
    while not selectedOption do
        io.write("Introduzca una opcion valida : ")

        input = io.read("l")
        input = tonumber(input) or input or options[1]
        selectedOption = options[input]
        result = input
    end

    return result
end

---Checks for a file, if it exists returns true, if no file is found returns false
---@param filePath string
---@return boolean
local function checkForFile(filePath)
    local file = io.open(filePath, "r")
    local result = not not file
    if not file then
         return false
    end
    file:close()
    return result
end

---Starts the module
---@param argumentList string[]
function module.init(argumentList)
    module.argumentList = argumentList
end

---Throws an error when the list is locked
---@param filePath string
function module.checkLock(filePath)
    local checkFile = checkForFile(filePath)

    if not checkFile then
        error("Ese archivo no existe!")
    end

    local file = io.open(filePath, "r")
    assert(file, "El archivo no se pudo abrir!")

    local firstLine = file:read("l")

    file:close()

    if firstLine == _LOCKED_STRING then
        error("Esa lista esta bloqueada y no se puede modificar!")
    end
end

---Locks a list preventing it from being open in write mode
---@param filePath string -- The list path
function module.lockList(filePath)
    local checkFile = checkForFile(filePath)

    if not checkFile then
        error("Ese archivo no existe!")
    end

    local file = io.open(filePath, "r")
    assert(file, "El archivo no se pudo abrir!")

    local firstLine = file:read("l")

    if firstLine == _LOCKED_STRING then
        error("Esta lista ya esta bloqueada!")
    end

    local fileContents = file:read("a")

    file:close()

    fileContents = _LOCKED_STRING .. "\n" .. firstLine .. "\n" .. fileContents

    file = io.open(filePath, "w+")
    assert(file, "El archivo no se pudo abrir!")

    file:write(fileContents)
    file:close()
end

---Unlocks a list
---@param filePath string
function module.unlockList(filePath)
    local checkFile = checkForFile(filePath)

    if not checkFile then
        error("Ese archivo no existe!")
    end

    local file = io.open(filePath, "r")
    assert(file, "El archivo no se pudo abrir!")

    local fileContents = file:read("a")

    file:close()

    local listElements = module.stringSplit(fileContents, "\n")

    if listElements[1] == _LOCKED_STRING then
        table.remove(listElements, 1)
    end

    file = io.open(filePath, "w+")
    assert(file, "El archivo no se pudo abrir!")

    file:write(table.concat(listElements, "\n"))
    file:close()
end

---Returns a list file open in read mode
---@param openMode "r" | "w" | "a" | "r+" | "w+" | "a+" | nil
---@return file*
function module.getList(openMode)
    openMode = openMode or "r"
    assertInit()
    for index, argument in pairs(module.argumentList) do
        if argument == "-l" then
            local file = io.open(module.argumentList[index + 1], openMode)

            assert(file, "No se puede abrir el archivo " .. module.argumentList[index + 1])

            return file
        end
    end
    error("No se indico ninguna lista!")
end

function module.getAltList(openMode)
    openMode = openMode or "r"
    assertInit()
    for index, argument in pairs(module.argumentList) do
        if argument == "-aL" then
            local file = io.open(module.argumentList[index + 1], openMode)
            return file
        end
    end
end

---Checks for the "-o" parameter and gives a file in which to write an output
---@return file* -- A file open in write+ mode (w+)
function module.getOutputFile()
    assertInit()
    for index, argument in pairs(module.argumentList) do
        if argument == "-o" then
            local filePath = module.argumentList[index + 1]

            local fileAlreadyExists = checkForFile(filePath)
            if fileAlreadyExists then
                module.checkLock(filePath)
                local response = module.promptUser("Ese archivo ya existe, estas seguro de sobreescribirlo?", {
                    s = "Si.",
                    n = "No."
                })

                if response == "n" then
                    error("Se nego sobreescribir el archivo")
                end
            end

            local file = io.open(filePath, "w+")
            assert(file, "No se logro abrir o crear el archivo")

            return file
        end
    end
    error("No se especifico un archivo de salida!")
end

---Returns true if the argument is find in the arg list
---@param argument string
---@return boolean -- true if the argument is present in the list
function module.checkForArgument(argument)
    assertInit()

    for i, v in pairs(module.argumentList) do
        if v == argument then
            return true
        end
    end

    return false
end

---Returns the argument value Ex : -argument HELLO! -> HELLO!, nil if none is found
---@param argument string
---@return string?
function module.getArgument(argument)
    assertInit()

    for i, v in pairs(module.argumentList) do
        if v == argument then
            return module.argumentList[i + 1]
        end
    end

    return nil
end

---Returns a table containing all the elements of the list
---@param list file* The list file to read from
---@return table<number>
function module.getListElements(list)
    if not list then return {} end
    local fileContents = list:read("a")

    local separatedListContents = module.stringSplit(fileContents, "\n")
    local resultList = {}
    for i, v in pairs(separatedListContents) do
        local num = tonumber(v)
        if num then
            table.insert(resultList, num)
        end
    end

    return resultList
end

return module
