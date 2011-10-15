require "controls"
require "polygon"
require "vector"

Player = {}
Player.__index = Player

local sprite = love.graphics.newImage("player.png")

function Player:new(x, y, state)
	local player = {}

	player.x = x
	player.y = y
	player.shape = Polygon:new(
		Vector:new(x, y),
		Vector:new(x + 32, y),
		Vector:new(x + 32, y + 32),
		Vector:new(x, y + 32)
	)

	player.velocity = Vector:new(0, 0)

	state:registerMove(player)
	state:registerKeys(player)

	return setmetatable(player, self)
end

function Player:move()
	self.velocity.x = (controls.right() and 4 or 0) - (controls.left() and 4 or 0)
	self.velocity.y = math.min(self.velocity.y + 0.5, 12)
end

function Player:collide(avail, normal, other)
	local vel = avail * self.velocity
	self.x = self.x + vel.x
	self.y = self.y + vel.y
	self.shape = self.shape + vel

	self.velocity = self.velocity - vel
	self.velocity = self.velocity - Vector.dot(self.velocity, normal) * normal
end

function Player:keypressed(key)
	if key == "up" then
		self.velocity.y = -12
	end
end

function Player:keyreleased(key)
	if key == "up" and self.velocity.y < 0 then
		self.velocity.y = self.velocity.y / 2
	end
end

function Player:draw()
	love.graphics.draw(sprite, math.floor(self.x), math.floor(self.y), 0, 1, 1, 0, 0)

	love.graphics.setCaption(love.timer.getFPS() .. " fps")
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print(self.x .. ", " .. self.y, 0, 0)
	love.graphics.print(self.velocity.x .. ", " .. self.velocity.y, 0, 11)
	love.graphics.setColor(255, 255, 255, 255)
end
