State = {}
State.__index = State

function State:new(image, tiles, bounds)
	local batch = love.graphics.newSpriteBatch(love.graphics.newImage(image))

	for y = 0, tiles.height - 1 do
		for x = 0, tiles.width - 1 do
			local px, py = x * tiles.tileWidth, y * tiles.tileHeight

			local tile = tiles[y][x]
			if tile then
				batch:addq(tile, px, py)
			end

			local bound = bounds[y][x]
			if bound > 0 then
				bounds[y][x] = Polygon:new(
					Vector:new(px, py), Vector:new(px + 32, py),
					Vector:new(px + 32, py + 32), Vector:new(px, py + 32)
				)
			else
				bounds[y][x] = nil
			end
		end
	end

	return setmetatable({ batch = batch, bounds = bounds, entities = {} }, self)
end

function State:addEntity(entity)
	self.entities[#self.entities] = entity
end

function State:draw()
	love.graphics.draw(self.batch)
	for _, entities in pairs(self.entities) do
		entities:draw()
	end
end
