Lib.start('ClassLib')
local path = Lib.curPath()

--=====
-- API
--=====

local ClassLibAPI = {}

---@type ClassDeclare
local ClassDeclare = require(path..'Declare')
---@type ClassName
local ClassName = require(path..'Name')
---@type ClassParent
local ClassParent = require(path..'Parent')
ClassParent.init()
---@type ClassPublic
local ClassPublic = require(path..'Public')
---@type ClassInstance
local ClassInstance = require(path..'Instance')
---@type ClassOverride
local ClassOverride = require(path..'Override')

ClassLibAPI.new = ClassDeclare.register
ClassLibAPI.allocate = ClassInstance.allocate
ClassLibAPI.isClass = ClassName.isClass
ClassLibAPI.isInstance = ClassInstance.isInstance
ClassLibAPI.getClass = ClassInstance.getClass
ClassLibAPI.isChild = ClassParent.isChild
ClassLibAPI.getPublic = ClassPublic.get
ClassLibAPI.getOverride = ClassOverride.get
ClassLibAPI.type = ClassDeclare.type

--=======
-- Debug
--=======

ClassLibAPI.getInstancesStatistics = ClassInstance.getStatistics

Lib.finish()

return ClassLibAPI