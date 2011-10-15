require "polygon"

local Door = {}
Door.__index = Door

local sequences = require "maps.door"
local sprite = love.graphics.newImage(sequences.image)
sprite:setFilter("nearest", "nearest")

local shape = Polygon:new(
	Vector:new(8, 0), Vector:new(24, 0),
	Vector:new(24, 32), Vector:new(8, 32)
)

function Door:new(x, y, id, state)
	local door = { x = x, y = y, frame = 0 }

	state.doors = state.doors or {}
	state.doors[id] = door

	door.shape = shape + Vector:new(x, y)
	state:registerSolid(door)

	return setmetatable(door, self)
end

function Door:open()
	self.shape = self.shape + Vector:new(0, -32)
	self.frame = 1
end

function Door:draw()
	local quad = sequences[1][self.frame]
	love.graphics.drawq(sprite, quad, self.x, self.y, 0, 1, 1, 0, 0)
end

return Door
