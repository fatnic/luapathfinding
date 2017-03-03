Wall = require 'wall'
Grid = require 'grid'
Pathfinder = require 'pathfinder'

w = {
    { 0, 0, love.graphics:getWidth(), love.graphics:getHeight(), true },
    { 5 * 16, 5 * 16, 1 * 16, 20 * 16 },
    { 20 * 16, 5 * 16, 1 * 16, 20 * 16 },
    { 21 * 16, 5 * 16, 19 * 16, 1 * 16 },
    { 21 * 16, 24 * 16, 14 * 16, 1 * 16 },
    { 6 * 16, 15 * 16, 14 * 16, 1 * 16 },
}

walls = {}
for _, wall in pairs(w) do table.insert(walls, Wall.new(unpack(wall))) end

start = { x = 35, y = 3 }
finish = { x = 25, y = 8 }

function love.load()
    grid = Grid.new(16, 40 * 16, 40 * 16)
    love.window.setMode(grid:pixelsize())
    grid:setWalls(walls)

    pathfinder = Pathfinder.new(grid, start.x, start.y, finish.x, finish.y)
    path = pathfinder:solve()
end

function love.update(dt)
    love.window.setTitle(love.timer.getFPS() .. ' fps')
end

function love.draw()
    grid:drawGrid()

    -- local mgrid = grid:xy2cell(love.mouse:getX(), love.mouse:getY())
    -- love.graphics.setColor(55, 0, 0)
    -- love.graphics.rectangle('fill', mgrid.x * grid:cellSize(), mgrid.y * grid:cellSize(), grid:cellSize(), grid:cellSize())

    love.graphics.setColor(0, 200, 0, 100)
    love.graphics.circle('fill', grid:cellCenter(start.x, start.y).x, grid:cellCenter(start.x, start.y).y, grid:cellSize() / 2)

    love.graphics.setColor(255, 255, 255, 100)
    love.graphics.circle('fill', grid:cellCenter(finish.x, finish.y).x, grid:cellCenter(finish.x, finish.y).y, grid:cellSize() / 2)

    for _, wall in pairs(walls) do wall:draw() end

    -- for _, p in pairs(pathfinder.searched) do
    --     local s = grid:cellCenter(p.x, p.y)
    --     love.graphics.setColor(255, 255, 255, 20)
    --     love.graphics.circle('fill', s.x, s.y, 5)
    -- end

    -- for _, b in pairs(pathfinder.blocklist) do
    --     local s = grid:cellCenter(b.x, b.y)
    --     love.graphics.setColor(255, 0, 0, 50)
    --     love.graphics.circle('fill', s.x, s.y, 5)
    -- end

    for _, w in pairs(path) do
        local s = grid:cellCenter(w.x, w.y)
        love.graphics.setColor(0, 255, 0, 150)
        love.graphics.circle('fill', s.x, s.y, 2)
    end
end
