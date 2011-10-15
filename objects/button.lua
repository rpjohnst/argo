require "polygon"

local Button = {}
Button.__index = Button

local sequences = require "maps.button"
local sprite = love.graphics.newImage(sequences.image)
sprite:setFilter("nearest", "nearest")

local shape = Polygon:new(
	Vector:new(0, 16), Vector:new(32, 16),
	Vector:new(32, 32), Vector:new(0, 32)
)

function Button:new(x, y, id, state)
	local button = { x = x, y = y, id = id, state = state, frame = 0 }

	button.shape = shape + Vector:new(x, y)
	state:registerIntersect(button)

	return setmetatable(button, self)
end

function Button:intersect(other)
	self.frame = 1
	self.state.doors[self.id]:open()
end

function Button:draw()
	local quad = sequences[1][self.frame]
	love.graphics.drawq(sprite, quad, self.x, self.y, 0, 1, 1, 0, 0)
end

return Button
