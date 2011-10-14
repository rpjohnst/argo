require "player"

State = {}
State.__index = State

function State:new(image, tiles, bounds, codes)
	local state = setmetatable({}, self)
	state.batch = love.graphics.newSpriteBatch(love.graphics.newImage(image))
	state.bounds = bounds
	state.entities = {}

	for y = 0, tiles.height - 1 do
		for x = 0, tiles.width - 1 do
			local px, py = x * tiles.tileWidth, y * tiles.tileHeight

			local tile = tiles[y][x]
			if tile then
				state.batch:addq(tile, px, py)
			end

			local bound = bounds[y][x]
			if bound > 0 then
				state.bounds[y][x] = Polygon:new(
					Vector:new(px, py), Vector:new(px + 32, py),
					Vector:new(px + 32, py + 32), Vector:new(px, py + 32)
				)
			else
				state.bounds[y][x] = nil
			end

			local code = codes[y][x]
			if code == 1 then
				local player = Player:new(px, py, state)
				state.entities[#state.entities + 1] = player
			end
		end
	end

	return state
end

function State:update()
	for _, entity in pairs(self.entities) do
		entity:update()
		entity:move(Vector:new(entity.xspeed, entity.yspeed))
	end
end

function State:keypressed(key)
	for _, entity in pairs(self.entities) do
		entity:keypressed(key)
	end
end

function State:keyreleased(key)
	for _, entity in pairs(self.entities) do
		entity:keyreleased(key)
	end
end

function State:draw()
	love.graphics.draw(self.batch)
	for _, entity in pairs(self.entities) do
		entity:draw()
	end
end
