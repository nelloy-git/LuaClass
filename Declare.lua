local ClassName = require('Name')
local ClassParent = require('Parent')
local ClassStatic = require('Static')
local ClassOverride = require('Override')
local ClassPublic = require('Public')
local ClassInstance = require('Instance')

---@class ClassDeclare
local ClassDeclare = {}

local type = type

local class_metatable = {
    __index = function(self, key)
        error('static, override, public are allowed only.', 2)
    end,

    __newindex = function(self, key)
        error('static, override, public are allowed only.', 2)
    end,

    __tostring = ClassName.getName
}

---@param name string
---@return any
function ClassDeclare.register(name, ...)
    if type(name) ~= 'string' then
        error('class name can be string only.', 2)
    end

    local class = {}
    ClassName.register(class, name)
    ClassParent.register(class, ...)
    class.static = ClassStatic.register(class)
    class.public = ClassPublic.register(class)
    class.override = ClassOverride.register(class)

    setmetatable(class, class_metatable)
    return class
end

---@param value1 any
---@param value2 any
---@return boolean
---@overload fun(value:any):string
---@overload fun(child_class:any, parent_class:any):boolean
---@overload fun(child:any, parent_class:any):boolean
---@overload fun(child:any, parent_instance:any):boolean
function ClassDeclare.type(value1, value2)
    if not value2 then
        if ClassName.isClass(value1) or ClassInstance.isInstance(value1) then
            return ClassName.getName(ClassStatic.getClass(value1) or value1)
        end
        return type(value1)
    end

    local is_class1 = ClassName.isClass(ClassStatic.getClass(value1) or value1)
    local is_class2 = ClassName.isClass(ClassStatic.getClass(value2) or value2)
    local is_instance1 = ClassInstance.isInstance(value1)
    local is_instance2 = ClassInstance.isInstance(value2)

    if not (is_class1 or is_class2 or is_instance1 or is_instance2) then
        return type(value1) == value2
    end

    if (is_class1 or is_instance1) ~= (is_class2 or is_instance2) then
        return false
    end

    local class1 = ClassStatic.getClass(value1) or value1
    local class2 = ClassStatic.getClass(value2) or value2

    if is_instance1 then
        class1 = ClassInstance.getClass(value1)
    end

    if is_instance2 then
        class2 = ClassInstance.getClass(value2)
    end

    return ClassParent.isChild(class1, class2)
end


return ClassDeclare