---@class ClassName
local ClassName = {}

local class2name = {}
local name2class = {}

-- Created in compiletime.
local class_first_register = {}
CompiletimeFinalToRuntime(function()
    class_first_register = Compiletime(class_first_register)
end)

---@param class table
---@param name string
function ClassName.register(class, name)
    if IsCompiletime() and name2class[name] then
        error('Class name must be unique. First one registered at '..GetSrcDir()..class_first_register[name], 3)
    end

    class2name[class] = name
    name2class[name] = class

    if IsCompiletime() then
        local info = debug.getinfo(3, "Sl")
        local path = info.source:sub(2)
        --local sep = package.config:sub(1,1)
        path = path:gsub('\\\\', '\\')
        path = path:gsub(GetSrcDir(), '')
        path = path..':'..tostring(info.currentline)
        class_first_register[name] = path
    end
end

---@param class table
---@return string
function ClassName.getName(class)
    return class2name[class]
end

---@param name string
---@return table
function ClassName.getClass(name)
    return name2class[name]
end

---@param any any
---@return boolean
function ClassName.isClass(any)
    if class2name[any] then
        return true
    end
    return false
end

return ClassName