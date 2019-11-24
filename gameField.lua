local Crystal = require("crystal")
local DisplayTool = require("displayTool")
local displayTool = DisplayTool:new();
GameField= {}
function GameField:new(row, column)
    local obj= {}
    obj.row = row
    obj.col = column
    obj.grid = {}
    obj.countChanges = 0
    self.__index = self;
    return setmetatable(obj, self)
end
--заполнить игровое поле
function GameField:init()
   math.randomseed(os.time())
   local color
    for i = 1, self.col do
        self.grid[i] = {}
        for j = 1, self.row do
            repeat
                color = getRandomColor()
            until not((i >= 3 and self.grid[i - 1][j].color == color and self.grid[i - 2][j].color == color)
                or (j >= 3 and self.grid[i][j - 1].color == color and self.grid[i][j - 2].color == color))
            self.grid[i][j] = Crystal:new(i,j,'standard', color)
        end
    end
    local moves = findMoves(self.grid)
    if (#moves <= 0) then
        self:init()
    end
end
--посчитать изменения на поле
function GameField:tick()
    self.countChanges = self.countChanges + 1;
    self:dump();
end
-- подвинуть кристалл на поле
function GameField:move(from,to)
    self.grid[from.x][from.y], self.grid[to.x][to.y] = self.grid[to.x][to.y], self.grid[from.x][from.y]
    self:tick();
    local matches = findMatches(self.grid);
    while #matches > 0 do
        removeMatches(matches, self.grid);
        self:tick();
        shiftCrystals(self.grid);
        self:tick();
        matches = findMatches(self.grid);
    end
    local moves = findMoves(self.grid)
    if (#moves == 0) then
        self:mix()
        self:tick()
    end
end
-- перемешать кристаллы на поле
function GameField:mix()
    math.randomseed(os.time())
    local m, n
    for i=self.col, 1, -1 do
        for j=self.row, 1, -1 do
            m = math.random(1, 10)
            n = math.random(1, 10)
            self.grid[i][j], self.grid[m][n] = self.grid[m][n], self.grid[i][j]
        end
    end
    local matches = findMatches(self.grid)
    local moves = findMoves(self.grid)
    if (#matches>0 or #moves == 0) then
        self:mix()
    end
end
--отобразить поле
function GameField:dump()
    displayTool:printTable(self.grid);
end
--получить рандомный цвет
function getRandomColor()
    local colors = {"A", "B", "C", "D", "E", "F"}
    return colors[math.random(1, 6)]
end;
--найти совпадения на поле
function findMatches(grid)
    local matches = {}
    local matchSize, checkMatch
    --поиск по горизонтали
    local k = 1;
    for j = 1, #grid[1] do
        matchSize = 1;
        for i=1,#grid do
            checkMatch = false;
            if (i == #grid) then
                checkMatch = true;
            else
                if (grid[i][j].color == grid[i+1][j].color) then
                    matchSize = matchSize+1;
                else
                    checkMatch = true;
                end;
            end;
            if checkMatch then
                if matchSize >=3 then
                    matches[k] = {x= i+1-matchSize, y=j, size= matchSize, horizontal= true};
                    k = k+1;
                end;
                matchSize = 1;
            end;
        end;
    end
    --поиск по вертикали
    for i=1,#grid do
        matchSize=1;
        for j=1, #grid[1] do
            checkMatch = false;
            if (j == #grid[1]) then
                checkMatch = true;
            else
                if (grid[i][j].color == grid[i][j+1].color) then
                    matchSize = matchSize + 1
                else
                    checkMatch = true
                end;
            end;
            if checkMatch then
                if matchSize >=3 then
                    matches[k] = {x= i, y=j+1-matchSize, size= matchSize, horizontal= false};
                    k = k+1;
                end;
                matchSize = 1;
            end;
        end;
    end;
    return matches;
end
--удалить совпадения кристаллов
function removeMatches(matches, grid)
    for k=1,#matches do
        grid[matches[k].x][matches[k].y].color = 0;
        for l=1,matches[k].size-1 do
            if (matches[k].horizontal) then
                grid[matches[k].x+l][matches[k].y].color = 0;
            else
                grid[matches[k].x][matches[k].y+l].color = 0;
            end;
        end;
    end;
end
--сместить кристаллы
function shiftCrystals(grid)
    math.randomseed(os.time())
    local shift;
    for i=1,#grid do
        shift = 0;
        for j=#grid[1], 1, -1 do
            if grid[i][j].color == 0 then
                shift = shift + 1;
                grid[i][j].color = getRandomColor()
            else
                if shift > 0 then
                    grid[i][j], grid[i][j+shift] = grid[i][j+shift], grid[i][j]
                end;
            end;
        end;
    end;
end
--найти возможные перемещения кристаллов на поле
function findMoves(grid)
    local moves = {}
    local k = 1;
    local matches;
    --поиск по горизонтали
    for j=1,#grid[1] do
        for i=1,#grid-1 do
            grid[i][j], grid[i+1][j] = grid[i+1][j], grid[i][j]
            matches = findMatches(grid)
            grid[i][j], grid[i+1][j] = grid[i+1][j], grid[i][j]
            if (#matches > 0) then
                moves[k] = {x1=i,y1=j,x2=i+1,y2=j}
                k = k+1
            end
        end
    end
    --поиск по вертикали
    for i=1,#grid do
        for j=1,#grid[1]-1 do
            grid[i][j], grid[i][j+1] = grid[i][j+1],grid[i][j]
            matches = findMatches(grid)
            grid[i][j], grid[i][j+1] = grid[i][j+1],grid[i][j]
            if (#matches > 0) then
                moves[k] = {x1=i,y1=j,x2=i,y2=j+1}
                k=k+1
            end

        end
    end
    return moves;
end
return GameField;