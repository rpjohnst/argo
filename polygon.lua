require "vector"

Polygon = {}
Polygon.__index = Polygon

function Polygon:new(...)
	return setmetatable({ ... }, self)
end

function Polygon.__add(polygon, vector)
	local p = Polygon:new(unpack(polygon))
	for i, v in pairs(p) do
		p[i] = v + vector
	end

	return p
end

-- average of the vertices
function Polygon:center()
	local x, y = 0, 0
	for i = 1, #self do
		x = x + self[i].x
		y = y + self[i].y
	end

	return Vector:new(x / #self, y / #self)
end

-- table of normals
function Polygon:normals()
	local normals = {}
	for i = 1, #self do
		local a, b = self[i], self[i % #self + 1]
		local edge = b - a
		normals[i] = Vector:new(edge.y, -edge.x):normalize()
	end

	return normals
end

-- min, max on axis
function Polygon:project(axis)
	local min, max = math.huge, -math.huge
	for i = 1, #self do
		local d = Vector.dot(self[i], axis)
		if d < min then
			min = d
		elseif d > max then
			max = d
		end
	end

	return min, max
end

-- distance or overlap of two intervals
local function diff(mina, maxa, minb, maxb)
	return mina < minb and minb - maxa or mina - maxb
end

-- percentage of velocity, collision normal
function Polygon.move(a, b, velocity)
	local maxVel, normal = -math.huge, nil

	local anormals, bnormals = a:normals(), b:normals()
	for i = 1, #a + #b do
		local axis = i <= #a and anormals[i] or bnormals[i - #a]

		local mina, maxa = a:project(axis)
		local minb, maxb = b:project(axis)

		local axisVel, fracVel = Vector.dot(velocity, axis), -math.huge
		if axisVel < 0 and mina >= maxb then
			local d = diff(mina + axisVel, maxa, minb, maxb)
			fracVel = math.min((axisVel - d) / axisVel, 1)
		elseif axisVel == 0 then
			local d = diff(mina, maxa, minb, maxb)
			fracVel = d >= 0 and 1 or -math.huge -- curse you lua, we need continue
		elseif axisVel > 0 and mina >= maxb then
			fracVel = 1
		end

		-- early out if we don't collide
		if fracVel == 1 then
			return 1, nil
		end

		if fracVel > maxVel then
			maxVel = fracVel
			normal = axis
		elseif fracVel == 0 and fracVel == maxVel and Vector.dot(velocity, axis) > Vector.dot(velocity, normal) then
			normal = axis
		end
	end

	assert(maxVel >= 0, "inside block")
	return maxVel, normal
end

-- whether polygons intersect
function Polygon.intersects(a, b)
	local anormals, bnormals = a:normals(), b:normals()
	for i = 1, #a + #b do
		local axis = i <= #a and anormals[i] or bnormals[i - #a]
		
		local mina, maxa = a:project(axis)
		local minb, maxb = b:project(axis)

		local d = diff(mina, maxa, minb, maxb)
		if d >= 0 then return false end
	end

	return true
end
