local mainModule = require("mainMod")
mainModule.init(arg)

local filePath = mainModule.getArgument("-l") or error("No se encontro ese archivo!")

mainModule.unlockList(filePath)