local PathSmoother = {}
PathSmoother.__index = PathSmoother

function PathSmoother.new(path)
    local self = setmetatable({}, PathSmoother)
    self.path = path
    return self
end

function PathSmoother:getPath()
    return self.path
end

return PathSmoother
