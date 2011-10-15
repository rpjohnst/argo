function love.run()
	love.load(arg)

	local nextFrame = love.timer.getTime()
	while true do
		love.timer.step()

		while nextFrame < love.timer.getTime() do
			for e, a, b, c in love.event.poll() do
				if e == "q" then
					love.audio.stop()
					return
				end
				love.handlers[e](a, b, c)
			end

			love.update()
			nextFrame = nextFrame + 1 / 60
		end

		love.graphics.clear()
		love.draw()
		love.graphics.present()
	end
end

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

function love.quit()
end
