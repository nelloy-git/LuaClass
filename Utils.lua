---@class ClassUtils
local ClassUtils = {}

function ClassUtils.deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = _G.type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            setmetatable(copy, ClassUtils.deepcopy(getmetatable(orig), copies))
            for orig_key, orig_value in next, orig, nil do
                copy[ClassUtils.deepcopy(orig_key, copies)] = ClassUtils.deepcopy(orig_value, copies)
            end
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return ClassUtils