require "vector"
require "polygon"

Entity = {}
Entity.__index = Entity

function Entity:new(x, y, shape)
	return setmetatable({}, self)
end

local xnorm = Vector:new(1, 0)
local ynorm = Vector:new(0, 1)
local empty = {}

function Entity:move(velocity)
	while velocity:magnitude() > 0 do
		local minx, maxx = self.shape:project(xnorm)
		local miny, maxy = self.shape:project(ynorm)

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

		local minVel, minNorm = 1, nil
		for y = math.floor(miny / 32), math.floor(maxy / 32) do
			for x = math.floor(minx / 32), math.floor(maxx / 32) do
				local other = (state.objects[y] or empty)[x]

				if other then -- curse you lua, should be continue
					local fracVel, normal = Polygon.intersects(self.shape, other.shape, velocity)
					if fracVel < minVel then
						minVel = fracVel
						minNorm = normal
					end
				end
			end
		end

		-- TODO: delegate collision response to the entity itself
		local vel = minVel * velocity
		self.x = self.x + vel.x
		self.y = self.y + vel.y
		self.shape = self.shape + vel

		velocity = velocity - vel
		minNorm = minNorm or Vector:new(0, 0)
		velocity = velocity - Vector.dot(velocity, minNorm) * minNorm
	end
end
