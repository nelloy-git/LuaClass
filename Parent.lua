local lib_path = Lib.curPath()

local ClassName = require(lib_path..'Name')

---@class ClassParent
local ClassParent = {}
local ClassStatic
function ClassParent.init()
    ClassStatic = ClassStatic or require(lib_path..'Static')
end

local fmt = string.format

local class2parents_list = {}
local class2parents = {}

local function isInList(elem, list)
    for i = 1, #list do
        if elem == list[i] then 
            return true
        end
    end
    return false
end

---@param class table
function ClassParent.register(class, ...)
    local vararg = {...}

    local parents_list = {}
    for i = 1, #vararg do
        vararg[i] = ClassStatic.getClass(vararg[i]) or vararg[i]
        if not ClassName.isClass(vararg[i]) then
            error(fmt('%d-th parent is not class', i), 3)
        end

        if not isInList(vararg[i], parents_list) then
            table.insert(parents_list, vararg[i])
        end

        local vararg_parents = class2parents_list[vararg[i]]
        for j = 1, #vararg_parents do
            if not isInList(vararg_parents[j], parents_list) then
                table.insert(parents_list, vararg_parents[j])
            end
        end
    end

    local parents = {}
    for i = 1, #parents_list do
        parents[parents_list[i]] = true
    end

    class2parents_list[class] = parents_list
    class2parents[class] = parents
end

---@param class table
---@return table[]
function ClassParent.getList(class)
    return class2parents_list[class]
end

---@param child table
---@param parent table
---@return boolean
function ClassParent.isChild(child, parent)
    return child == parent or class2parents[child][parent] or false
end

return ClassParent