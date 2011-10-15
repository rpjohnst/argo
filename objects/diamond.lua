require "polygon"

local Diamond = {}
Diamond.__index = Diamond

local sequences = require "maps.diamond"
local sprite = love.graphics.newImage(sequences.image)
sprite:setFilter("nearest", "nearest")

local shape = Polygon:new(
	Vector:new(16, 0), Vector:new(32, 16),
	Vector:new(16, 32), Vector:new(0, 16)
)

function Diamond:new(x, y, id, state)
	local diamond = { x = x, y = y }

	diamond.shape = shape + Vector:new(x, y)
	state:registerIntersect(diamond)

	return setmetatable(diamond, self)
end

function Diamond:intersect(other)
	state.frame = 0
	state.message = "WIN"
end

function Diamond:draw()
	local quad = sequences[1][0]
	love.graphics.drawq(sprite, quad, self.x, self.y, 0, 1, 1, 0, 0)
end

return Diamond
