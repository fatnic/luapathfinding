local Grid = {}
Grid.__index = Grid

function Grid.new(size, pixelwidth, pixelheight, walls)
    local self = setmetatable({}, Grid)
    self.cellsize = size
    self.pixels = { x = pixelwidth, y = pixelheight }
    self.gridwidth = pixelwidth / self.cellsize
    self.gridheight = pixelheight / self.cellsize
    self.grid = self:blankGrid()
    self.walls = nil
    return self
end

function Grid:blankGrid()
    local grid = {}
    for i=1, self.gridheight do
        local row = {}
        for r=1, self.gridwidth do
            table.insert(row, 0)
        end
        table.insert(grid, row)
    end
    return grid
end

function Grid:setWalls(walls)
    self.walls = walls
    for _, wall in pairs(walls) do
        if wall.visible then
            local ctl = grid:xy2cell(wall.points[1].x, wall.points[1].y) 
            local cw = wall.width / self.cellsize
            local ch = wall.height / self.cellsize
            for row = ctl.y + 1, ctl.y + ch do
                for col = ctl.x + 1, ctl.x + cw do
                    self.grid[row][col] = 1
                end
            end
        end
    end
end

function Grid:cell2xy(col, row)
    local x = col * self.cellsize - self.cellsize
    local y = row * self.cellsize - self.cellsize
    return { x = x, y = y }
end

function Grid:cellCenter(col, row)
    local cx = (col * self.cellsize) - (self.cellsize / 2)
    local cy = (row * self.cellsize) - (self.cellsize / 2)
    return { x = cx, y = cy }
end

function Grid:xy2cell(x, y)
    local cx = math.floor(x / self.cellsize)
    local cy = math.floor(y / self.cellsize)
    return { x = cx, y = cy }
end

function Grid:drawGrid()
    for row=1, self.gridheight do
        for col=1, self.gridwidth do
            local gp = grid:cell2xy(col, row)
            love.graphics.setColor(0, 0, 55)
            love.graphics.rectangle('line', gp.x, gp.y, self.cellsize, self.cellsize)

            -- local gc = grid:cellCenter(col, row)
            -- if self.grid[row][col] == 0 then love.graphics.setColor(155, 155, 0) end
            -- if self.grid[row][col] == 1 then love.graphics.setColor(255, 5, 0) end
            -- love.graphics.points(gc.x, gc.y)
        end
    end
end

function Grid:printGrid()
    for _, row in pairs(self.grid) do
        local rstring = ""
        for _, cell in pairs(row) do
            rstring = rstring .. tostring(cell) .. " "        
        end
        print(rstring)
    end
end

function Grid:at(col, row)
    return self.grid[row][col]
end

function Grid:pixelsize() return self.pixels.x, self.pixels.y end
function Grid:getGrid() return self.grid end
function Grid:cellSize() return self.cellsize end
function Grid:gridWidth() return self.gridwidth end
function Grid:gridHeight() return self.gridheight end

return Grid
