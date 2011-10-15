require "polygon"
require "vector"
require "player"

State = {}
State.__index = State

function State:new(image, tiles, bounds, codes)
	local state = setmetatable({}, self)
	state.batch = love.graphics.newSpriteBatch(love.graphics.newImage(image))
	state.bounds = bounds

	state.entities = {}
	state.move = {}
	state.keys = {}

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

function State:registerMove(entity)
	self.move[#self.move + 1] = entity
end

function State:update()
	for _, entity in pairs(self.move) do
		entity:move()
		self:moveEntity(entity, entity.velocity)
	end
end

local xnorm = Vector:new(1, 0)
local ynorm = Vector:new(0, 1)
local empty = {}

function State:moveEntity(entity, velocity)
	while velocity:magnitude() > 0 do
		local minx, maxx = entity.shape:project(xnorm)
		local miny, maxy = entity.shape:project(ynorm)

		if velocity.x > 0 then
			maxx = maxx + velocity.x
		elseif velocity.x < 0 then
			minx = minx + velocity.x
		end

		if velocity.y > 0 then
			maxy = maxy + velocity.y
		elseif velocity.y < 0 then
			miny = miny + velocity.y
		end

		local minVel, minNorm, other = 1, nil, nil
		for y = math.floor(miny / 32), math.floor(maxy / 32) do
			for x = math.floor(minx / 32), math.floor(maxx / 32) do
				local shape = (self.bounds[y] or empty)[x]

				if shape then -- curse you lua, should be continue
					local fracVel, normal = Polygon.intersects(entity.shape, shape, velocity)
					if fracVel < minVel then
						minVel = fracVel
						minNorm = normal
						other = shape
					end
				end
			end
		end

		if minVel == 1 then
			entity.x = entity.x + velocity.x
			entity.y = entity.y + velocity.y
			entity.shape = entity.shape + velocity
			break
		else
			entity:collide(minVel, minNorm, other)
			velocity = entity.velocity
		end
	end
end

function State:registerKeys(entity)
	self.keys[#self.keys + 1] = entity
end

function State:keypressed(key)
	for _, entity in pairs(self.keys) do
		entity:keypressed(key)
	end
end

function State:keyreleased(key)
	for _, entity in pairs(self.keys) do
		entity:keyreleased(key)
	end
end

function State:draw()
	love.graphics.draw(self.batch)
	for _, entity in pairs(self.entities) do
		entity:draw()
	end
end
