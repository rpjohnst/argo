require "vector"
require "polygon"

Block = Entity:new()
Block.__index = Block

local sprite = love.graphics.newImage("block.png")

function Block:new(x, y)
	local block = {}

	block.x = x
	block.y = y
	block.shape = Polygon:new(
		Vector:new(x, y),
		Vector:new(x + 32, y),
		Vector:new(x + 32, y + 32),
		Vector:new(x, y + 32)
	)

	return setmetatable(block, self)
end

function Block:draw()
	love.graphics.draw(sprite, self.x, self.y, 0, 1, 1, 0, 0)
end
