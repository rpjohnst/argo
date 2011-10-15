local Button = {}
Button.__index = Button

local sequences = require "maps.button"
local sprite = love.graphics.newImage(sequences.image)

function Button:new(x, y, id, state)
	buttons = buttons or {}
	buttons[id] = false

	return setmetatable({ x = x, y = y, frame = 0 }, self)
end

function Button:draw()
	local quad = sequences[1][self.frame]
	love.graphics.drawq(sprite, quad, self.x, self.y, 0, 1, 1, 0, 0)
end

return Button
