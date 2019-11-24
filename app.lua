local GameField = require("gameField")
--начать игру
function startPlay()
    print("Hi! Start to play!")
    local row = 10
    local column = 10
    local gameField = GameField:new(row, column)
    gameField:init()
    gameField:dump()
    repeat
        io.write("Type command like 'm 3 0 r': ")
        io.flush()
        local cmd = io.read()
        local result = parseCmd(cmd)
        if (result.isValid) then
            gameField:move(result.coords.from, result.coords.to)
        else
            if cmd ~= "q" then
                print("Wrong command!")
            else
                print("Bye!Bye!")
            end
        end
    until cmd == "q"
    os.exit()
end
--разобрать введенную пользователем команду
function parseCmd(cmd)
    local result
    local isValid = cmd:match("^m%s%d%s%d%s[lrud{1}]")
    if isValid then
        if isValid ~= cmd then
            isValid = false
            result = {isValid = isValid}
        else
            str = {}
            i = 1
            for w in cmd:gmatch("%S+") do
                str[i] = w
                i = i + 1
            end
            local x = tonumber(str[2])
            local y = tonumber(str[3])
            local direction = str[4]
            if
                (x == 0 and direction == "l") or (x == 9 and direction == "r") or (y == 0 and direction == "u") or
                    (y == 9 and direction == "d")
             then
                isValid = false
                result = {isValid = isValid}
            else
                isValid = true
                local newx, newy
                if direction == "l" then
                    newx = x - 1
                    newy = y
                elseif direction == "r" then
                    newx = x + 1
                    newy = y
                elseif direction == "u" then
                    newx = x
                    newy = y - 1
                elseif direction == "d" then
                    newx = x
                    newy = y + 1
                end
                local from = {x = x + 1, y = y + 1}
                local to = {x = newx + 1, y = newy + 1}
                result = {isValid = isValid, coords = {from = from, to = to}}
            end
        end
    else
        result = {isValid = isValid}
    end
    return result
end

startPlay()
