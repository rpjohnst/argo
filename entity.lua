require "vector"
require "polygon"

Entity = {}
Entity.__index = Entity

function Entity:new(x, y, shape)
	return setmetatable({}, self)
end
