LibManager.startLib('LuaClass')

--=====
-- API
--=====

local ClassLibAPI = {}

---@type ClassDeclare
local ClassDeclare = require('Declare')
---@type ClassName
local ClassName = require('Name')
---@type ClassParent
local ClassParent = require('Parent')
ClassParent.init()
---@type ClassPublic
local ClassPublic = require('Public')
---@type ClassInstance
local ClassInstance = require('Instance')
---@type ClassOverride
local ClassOverride = require('Override')

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

LibManager.endLib()

return ClassLibAPI