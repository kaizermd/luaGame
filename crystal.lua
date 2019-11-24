Crystal= {}
function Crystal:new(x, y, type, color)
    local obj= {}
        obj.x = x
        obj.y = y
        obj.type = type -- тип кристалла (например, 'standard' or 'special')
        obj.color = color
    setmetatable(obj, self)
    self.__index = self; return obj
end
return Crystal;