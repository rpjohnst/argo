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

function love.load()
	love.graphics.setBackgroundColor(255, 255, 255)
	state = require "levels.start"
end

function love.update()
	state:update()
end

function love.keypressed(key)
	state:keypressed(key)

	if key == "escape" then
		love.event.push("q")
	end
end

function love.keyreleased(key)
	state:keyreleased(key)
end

function love.draw()
	state:draw()
end
