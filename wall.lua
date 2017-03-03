local Wall = {}
Wall.__index = Wall

function Wall.new(x, y, w, h, visible)
    local self = setmetatable({}, Wall)
    
    self.position = { x = x, y = y }
    self.width, self.height = w, h
    self.visible = not visible

    self.segments = {}
    table.insert(self.segments, { a = { x = x, y = y }, b = { x = x + w, y = y } })
    table.insert(self.segments, { a = { x = x + w, y = y }, b = { x = x + w, y = y + h } })
    table.insert(self.segments, { a = { x = x + w, y = y + h }, b = { x = x, y = y + h } })
    table.insert(self.segments, { a = { x = x, y = y + h }, b = { x = x, y = y } })

    self.points = {}
    for _, segment in pairs(self.segments) do
        table.insert(self.points, segment.a)
    end

    return self
end

function Wall:draw()
    if not self.visible then return end
    love.graphics.setColor(0, 0, 200)
    for _, segment in pairs(self.segments) do
        love.graphics.line(segment.a.x, segment.a.y, segment.b.x, segment.b.y)
    end
end

return Wall
