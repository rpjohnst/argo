local Door = {}
Door.__index = Door

local sequences = require "maps.door"
local sprite = love.graphics.newImage(sequences.image)

function Door:new(x, y, id, state)
	return setmetatable({ x = x, y = y, frame = 0 }, self)
end

function Door:draw()
	local quad = sequences[1][self.frame]
	love.graphics.drawq(sprite, quad, self.x, self.y, 0, 1, 1, 0, 0)
end

return Door
