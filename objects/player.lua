require "controls"
require "polygon"

local Player = {}
Player.__index = Player

local sequences = require "maps.player"
local sprite = love.graphics.newImage(sequences.image)
sprite:setFilter("nearest", "nearest")

function Player:new(x, y, data, state)
	local player = {}

	player.x = x
	player.y = y
	player.shape = Polygon:new(
		Vector:new(x, y), Vector:new(x + 32, y),
		Vector:new(x + 32, y + 32), Vector:new(x, y + 32)
	)
	player.frame = 0

	player.velocity = Vector:new(0, 0)

	state:registerMove(player)
	state:registerSolid(player)
	state:registerIntersect(player)
	state:registerKeys(player)
	state.player = player

	return setmetatable(player, self)
end

function Player:move()
	self.velocity.x = (controls.right() and 4 or 0) - (controls.left() and 4 or 0)
	self.velocity.y = math.min(self.velocity.y + 0.5, 12)

	self.frame = self.frame + (controls.right() and 1 or 0) - (controls.left() and 1 or 0)

	local scale = math.min(1 - (self.y - 500) / 500, 1)
	love.graphics.setBackgroundColor(128 * scale, 200 * scale, 255 * scale)
	if self.y > 800 then
		state = love.filesystem.load("maps/start.lua")()
	end
end

function Player:collide(avail, normal, other)
	local vel = avail * self.velocity
	self.x = self.x + vel.x
	self.y = self.y + vel.y
	self.shape = self.shape + vel

	self.velocity = self.velocity - vel
	self.velocity = self.velocity - Vector.dot(self.velocity, normal) * normal
end

function Player:intersect(other)
end

function Player:keypressed(key)
	if key == "up" and not state:placeFree(self, Vector:new(0, 1)) then
		self.velocity.y = -12
	end
end

function Player:keyreleased(key)
	if key == "up" and self.velocity.y < 0 then
		self.velocity.y = self.velocity.y / 2
	end
end

function Player:draw()
	local quad = sequences[1][self.frame % 8]
	love.graphics.drawq(sprite, quad, self.x, self.y, 0, 1, 1, 16, 32)
end

return Player
