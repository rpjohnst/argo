require "player"
require "polygon"

local player

function love.load()
	love.graphics.setBackgroundColor(255, 255, 255)

	state = require "levels.start"

	player = Player:new(32, 32)
	state:addEntity(player)
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
	state:draw()

	love.graphics.setCaption(love.timer.getFPS() .. " fps")
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print(player.x .. ", " .. player.y, 0, 0)
	love.graphics.print(player.xspeed .. ", " .. player.yspeed, 0, 11)
	love.graphics.setColor(255, 255, 255, 255)
end
