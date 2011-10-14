Vector = {}
Vector.__index = Vector

function Vector:new(x, y)
	return setmetatable({ x = x or 0, y = y or 0 }, self)
end

function Vector:magnitude()
	return math.sqrt(self.x * self.x + self.y * self.y);
end

function Vector:normalize()
	return getmetatable(self):new(self.x / self:magnitude(), self.y / self:magnitude())
end

function Vector.dot(a, b)
	return a.x * b.x + a.y * b.y
end

function Vector.__add(a, b)
	return Vector:new(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
	return Vector:new(a.x - b.x, a.y - b.y)
end

function Vector.__mul(a, b)
	return Vector:new(a * b.x, a * b.y)
end
