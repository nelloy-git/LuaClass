local lib_path = Lib.curPath()

local ClassName = require(lib_path..'Name')
local ClassPublic = require(lib_path..'Public')

---@class ClassInstance
local ClassInstance = {}

local instance2class = {}
setmetatable(instance2class, {__mode = 'kv'})

local fmt = string.format

local instance_metatable
instance_metatable = {
    __index = function(self, key)
        error(fmt('%s: public field \'%s\' does not exist.', self, key), 2)
    end,

    __newindex = function(self, key, value)
        error(fmt('%s: public field \'%s\' does not exist.', self, key), 2)
    end,

    __tostring = function(self)
        setmetatable(self, nil)
        local def = tostring(self)
        setmetatable(self, instance_metatable)
        local class = instance2class[self]
        return ClassName.getName(class)..'_'..string.sub(def, 10)
    end,
}

---@param class table
---@return table
function ClassInstance.allocate(class)
    local instance = {}

    local public = ClassPublic.get(class)
    for k,v in pairs(public) do
        instance[k] = v
    end

    setmetatable(instance, instance_metatable)
    instance2class[instance] = class
    return instance
end

---@param instance table
---@rettrn table
function ClassInstance.getClass(instance)
    return instance2class[instance]
end


---@param instance table
---@rettrn boolean
function ClassInstance.isInstance(instance)
    if instance2class[instance] then
        return true
    end
    return false
end

function ClassInstance.getStatistics()
    local res = {}
    for _, class in pairs(instance2class) do
        res[class] = (res[class] or 0) + 1
    end
    return res
end

return ClassInstance