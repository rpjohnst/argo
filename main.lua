require "player"
require "block"
require "polygon"

local player
local blocks = {}

function love.load()
	love.graphics.setBackgroundColor(255, 255, 255)

	player = Player:new(32, 32)
	for i = 1, 10 do
		blocks[#blocks + 1] = Block:new(32 * i, 32 * 11)
	end
	for i = 1, 3 do
		blocks[#blocks + 1] = Block:new(32 * 10, 32 * (11 - i))
	end
end

--[[
function love.run()
	love.load(arg)

	local nextFrame = love.timer.getTime()
	while true do
		while love.timer.getTime() < nextFrame do
			love.timer.step() -- update fps
			love.update()
		end

		if love.graphics then
			love.graphics.clear()
			if love.draw then
				love.draw()
			end
		end

		if love.events then
			for e, a, b, c in love.event.poll() do
				if e == "q" then
					if not love.quit or not love.quit() then
						if love.audio then
							love.audio.stop()
						end
						return
					end
				end
				love.handlers[e](a, b, c)
			end
		end

		if love.timer then love.timer.sleep(1) end
		if love.graphics then love.graphics.present() end
	end
end
]]

-- TODO: this should be in entity and access blocks through a global gamestate or something
function Entity:move(velocity)
	-- TODO: this should delegate collision response to the entity itself
	local loops = 0
	while velocity:magnitude() > 0 do
		local minVel, minNorm = 1, nil
		for _, other in pairs(blocks) do
			local fracVel, normal = Polygon.intersects(self.shape, other.shape, velocity)
			if fracVel < minVel then
				minVel = fracVel
				minNorm = normal
			end
		end

		local vel = minVel * velocity
		self.x = self.x + vel.x
		self.y = self.y + vel.y
		self.shape = self.shape + vel

		velocity = velocity - vel
		minNorm = minNorm or Vector:new(0, 0)
		velocity = velocity - Vector.dot(velocity, minNorm) * minNorm
	end
end

function love.update()
	player:update()
	player:move(Vector:new(player.xspeed, player.yspeed))
end

function love.keypressed(key)
	player:keypressed(key)

	if key == "escape" then
		love.event.push("q")
	end
end

function love.keyreleased(key)
	player:keyreleased(key)
end

function love.draw()
	player:draw()
	for _, block in pairs(blocks) do
		block:draw()
	end

	love.graphics.setCaption(love.timer.getFPS() .. " fps")
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print(player.x .. ", " .. player.y, 0, 0)
	love.graphics.print(player.xspeed .. ", " .. player.yspeed, 0, 11)
	love.graphics.setColor(255, 255, 255, 255)
end
