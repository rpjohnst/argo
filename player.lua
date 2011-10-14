require "entity"
require "controls"

Player = Entity:new()
Player.__index = Player

local sprite = love.graphics.newImage("player.png")

function Player:new(x, y)
	local player = {}

	player.x = x
	player.y = y
	player.shape = Polygon:new(
		Vector:new(x, y),
		Vector:new(x + 32, y),
		Vector:new(x + 32, y + 32),
		Vector:new(x, y + 32)
	)

	player.xspeed = 0
	player.yspeed = 0

	return setmetatable(player, self)
end

function Player:update()
	self.xspeed = (controls.right() and 4 or 0) - (controls.left() and 4 or 0)
	self.yspeed = math.min(self.yspeed + 0.5, 12)
end

function Player:keypressed(key)
	if key == "up" then
		self.yspeed = -12
	end
end

function Player:keyreleased(key)
	if key == "up" and self.yspeed < 0 then
		self.yspeed = self.yspeed / 2
	end
end

function Player:draw()
	love.graphics.draw(sprite, math.floor(self.x), math.floor(self.y), 0, 1, 1, 0, 0)

	love.graphics.setCaption(love.timer.getFPS() .. " fps")
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print(self.x .. ", " .. self.y, 0, 0)
	love.graphics.print(self.xspeed .. ", " .. self.yspeed, 0, 11)
	love.graphics.setColor(255, 255, 255, 255)
end
