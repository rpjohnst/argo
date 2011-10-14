require "player"
require "block"
require "polygon"

local player

state = {
	objects = {},
	draw = {}
}

function love.load()
	love.graphics.setBackgroundColor(255, 255, 255)

	player = Player:new(32, 32)
	state.draw[#state.draw + 1] = player

	for y = 1, math.floor(600 / 32) do
		state.objects[y] = {}
		if 7 <= y and y < 11 then
			state.objects[y][1] = Block:new(32 * 1, 32 * y)
			state.objects[y][10] = Block:new(32 * 10, 32 * y)
			state.draw[#state.draw + 1] = state.objects[y][1]
			state.draw[#state.draw + 1] = state.objects[y][10]
		elseif y == 11 then
			for x = 1, 10 do
				state.objects[y][x] = Block:new(32 * x, 32 * y)
				state.draw[#state.draw + 1] = state.objects[y][x]
			end
		end
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
	for _, object in pairs(state.draw) do
		object:draw()
	end

	love.graphics.setCaption(love.timer.getFPS() .. " fps")
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print(player.x .. ", " .. player.y, 0, 0)
	love.graphics.print(player.xspeed .. ", " .. player.yspeed, 0, 11)
	love.graphics.setColor(255, 255, 255, 255)
end
