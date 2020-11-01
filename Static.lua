local lib_path = Lib.curPath()

local ClassParent = require(lib_path..'Parent')

---@class ClassStatic
local ClassStatic = {}

local rawget = rawget
local rawset = rawset
local fmt = string.format

local class2static = {}
local static2class = {}

local static_meta = {
    __index = function(self, key)
        local parents = ClassParent.getList(static2class[self])
        for i = 1, #parents do
            local cur = class2static[parents[i]]
            local value = rawget(cur, key)
            if value then
                return value
            end
        end
        error(fmt(tostring(self)..': static field \'%s\' does not exist.', key), 2)
    end,

    __newindex = function(self, key, value)
        local parents = ClassParent.getList(static2class[self])
        for i = 1, #parents do
            local cur = class2static[parents[i]]
            if rawget(cur, key) then
                rawset(cur, key, value)
                return
            end
        end
        rawset(self, key, value)
    end,

    __tostring = function(self)
        return tostring(static2class[self])
    end,

    __pairs = function(self)
        local class = static2class[self]
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

                cur_table = class2static[parents[cur_pos]]
                return getKeyValue()
            end
        end

        return getKeyValue
    end
}

---@param class table
---@return table
function ClassStatic.register(class)
    local static = {}
    setmetatable(static, static_meta)

    class2static[class] = static
    static2class[static] = class
    return static
end

---@param class table
---@return table
function ClassStatic.getStatic(class)
    return class2static[class]
end

---@param static table
---@return table
function ClassStatic.getClass(static)
    return static2class[static]
end

return ClassStatic