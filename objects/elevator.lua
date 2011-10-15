require "polygon"

local Elevator = {}
Elevator.__index = Elevator

local sequences = require "maps.elevator"
local sprite = love.graphics.newImage(sequences.image)
sprite:setFilter("nearest", "nearest")

local shape = Polygon:new(
	Vector:new(0, 0), Vector:new(32, 0),
	Vector:new(32, 32), Vector:new(0, 32)
)

function Elevator:new(x, y, id, state)
	local elevator = {}

	elevator.x = x
	elevator.y = y
	elevator.shape = shape + Vector:new(x, y)
	elevator.velocity = Vector:new(0, -2)

	state:registerMove(elevator)
	state:registerSolid(elevator)

	return setmetatable(elevator, self)
end

function Elevator:move()
	if self.y <= -32 then
		self.y = self.y + 750
		self.shape = self.shape + Vector:new(0, 750)
	end
end

function Elevator:collide(avail, normal, other)
	local vel = self.velocity

	other.x = other.x + vel.x
	other.y = other.y + vel.y
	other.shape = other.shape + vel
end

function Elevator:draw()
	local quad = sequences[1][0]
	love.graphics.drawq(sprite, quad, self.x, self.y, 0, 1, 1, 0, 0)
end

return Elevator
