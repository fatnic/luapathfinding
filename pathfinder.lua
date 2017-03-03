local Node = {}
Node.__index = Node

function Node.new(x, y, g, h, f, parent)
    local self = setmetatable({}, Node)
    self.x = x
    self.y = y
    self.g = g
    self.h = h
    self.f = f
    self.parent = parent
    return self
end

function Node:equal(node)
    return self.x == node.x and self.y == node.y
end

local Pathfinder = {}
Pathfinder.__index = Pathfinder

function Pathfinder.new(grid, sx, sy, gx, gy)
    local self = setmetatable({}, Pathfinder)
    self.grid = grid
    self.cutcorners = false
    self.start = { x = sx, y = sy }
    self.goal = { x = gx, y = gy }
    --
    self.searched = {}
    self.blocklist = {}
    return self
end

function Pathfinder:setStart(x, y)
    self.start = { x = x, y = y }
end

function Pathfinder:setGoal(x, y)
    self.goal = { x = x, y = y }
end

function Pathfinder:solve()
    local openlist = {}
    local closedlist = {}
    local finalpath = {}

    table.insert(openlist, Node.new(self.start.x, self.start.y, 0, 0, 0, nil)) 

    while next(openlist) do

        table.sort(openlist, function(a, b) return a.f < b.f end)

        local current = table.remove(openlist, 1)
        table.insert(self.searched, current)
        table.insert(closedlist, current)
        
        if current:equal(self.goal) then
            local waypoints = {}
            while current.parent ~= nil do
                table.insert(waypoints, { x = current.x, y = current.y })
                current = current.parent
            end
            for i=#waypoints, 1, -1 do table.insert(finalpath, waypoints[i]) end
            return finalpath
        end
        
        local neighbours = self:calculateNeighbours(current)

        for n=0, 8 do

            local ignore = false

            local nx = math.floor(n % 3) - 1
            local ny = math.floor(n / 3) - 1
           
            local neighbour = { x = current.x + nx, y = current.y + ny }

            if not neighbours[n+1] then
                if n ~= 4 and neighbour.x > 0 and neighbour.y > 0 then
                    table.insert(self.blocklist, neighbour)
                end
                ignore = true
            end

            if self:inlist(closedlist, neighbour) then ignore = true end

            if not ignore then

                local g = self:distance(current, neighbour)
                local h = self:manhatten(neighbour, self.goal)
                local f = g + h

                if not self:inlist(openlist, neighbour) then
                    table.insert(openlist, Node.new(neighbour.x, neighbour.y, g, h, f, current)) 
                else
                    for _, node in pairs(openlist) do
                        if node:equal(neighbour) and g < node.g then
                            node.g = g
                            node.f = g + node.h
                            node.parent = current
                        end
                    end
                    table.sort(openlist, function(a, b) return a.f < b.f end)
                end
            end

        end
    end

    return finalpath
end

function Pathfinder:inlist(tbl, node)
    for _, n in pairs(tbl) do
        if n.x == node.x and n.y == node.y then return true end
    end
    return false
end

function Pathfinder:distance(n1, n2)
    local dx = n1.x - n2.x
    local dy = n1.y - n2.y
    return math.sqrt(dx * dx + dy * dy)
end

function Pathfinder:manhatten(n1, n2)
    local dx = math.abs(n1.x - n2.x)
    local dy = math.abs(n1.y - n2.y)
    return dx + dy
end

function Pathfinder:calculateNeighbours(node)
    local neighbours = {}
    for i=0, 8 do
        local nx = math.floor(i % 3) - 1
        local ny = math.floor(i / 3) - 1
        local col, row = node.x + nx, node.y + ny
        neighbours[i+1] = not self:blocked(col, row)
    end
    neighbours[5] = false

    if not self.cutcorners then
        if not neighbours[2] then neighbours[1] = false; neighbours[3] = false end
        if not neighbours[4] then neighbours[1] = false; neighbours[7] = false end
        if not neighbours[6] then neighbours[3] = false; neighbours[9] = false end
        if not neighbours[8] then neighbours[7] = false; neighbours[9] = false end
    end

    return neighbours
end

function Pathfinder:blocked(col, row)
    if col < 1 or col > self.grid:gridWidth() then return true end
    if row < 1 or row > self.grid:gridHeight()  then return true end
    if self.grid:at(col, row) == 1 then return true end
    return false
end

return Pathfinder
