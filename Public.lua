local lib_path = Lib.curPath()

local ClassStatic = require(lib_path..'Static')
local ClassUtils = require(lib_path..'Utils')
local ClassParent = require(lib_path..'Parent')

---@class ClassPublic
local ClassPublic = {}

local rawset = rawset
local deepcopy = ClassUtils.deepcopy

local class2public = {}
local public2class = {}

local NIL = '__RESERVED__'

local public_meta = {
    __newindex = function(self, key, value)
        if value == nil then
            value = NIL
        end
        rawset(self, key, value)
    end,

    __index = function(self, key)
        local val = rawget(self, key)

        if val ~= nil then
            return val
        end

        local class = public2class[self]
        local parents = ClassParent.getList(class)

        for i = 1, #parents do
            val = class2public[parents[i]][key]
            if val ~= nil then
                return val
            end
        end

        return val
    end,

    __tostring = function(self)
        return tostring(public2class[self])
    end,

    __pairs = function(self)
        local class = public2class[self]
        local parents = ClassParent.getList(class)

        local k, v
        local cur_pos = 0
        local cur_table = self
        local list = {}
        local function getKeyValue()
            k, v = next(cur_table, k)
            if k ~= nil then
                if list[k] ~= nil then
                    getKeyValue()
                end

                if k ~= nil then
                    list[k] = v
                end

                return k, v
            else
                cur_pos = cur_pos + 1
                if cur_pos > #parents then
                    return
                end

                cur_table = class2public[parents[cur_pos]]
                return getKeyValue()
            end
        end

        return getKeyValue
    end
}

---@param class table
---@return table
function ClassPublic.register(class)
    local public = {}
    setmetatable(public, public_meta)

    class2public[class] = public
    public2class[public] = class
    return public
end

---@param class table
---@return table
function ClassPublic.get(class)
    class = ClassStatic.getClass(class) or class
    return class2public[class]
end

return ClassPublic