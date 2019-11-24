DisplayTool = {}
function DisplayTool:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end
--вывести игровое поле на экран
function DisplayTool:printTable(table)
    local str = {}
    local firstStr = "  "
    local secondStr = "  "
    for i = 1, #table[1] do
        str[i] = i - 1 .. "|"
        firstStr = firstStr .. i - 1 .. " "
        secondStr = secondStr .. "-" .. " "
        for j = 1, #table do
            str[i] = str[i] .. table[j][i].color .. " "
        end
    end
    print(firstStr)
    print(secondStr)
    for i = 1, #str do
        print(str[i])
    end
end
return DisplayTool
