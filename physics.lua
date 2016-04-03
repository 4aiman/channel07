require "level"
require "vector"

local vec = vector

physics = {}

local abs = math.abs
local floor = math.floor
local ceil = math.ceil

function physics.moveentity(entity, dx, dy, grid, solidpredicate)
	solidpredicate = solidpredicate or physics.solidpredicate
	local inc
	while dx ~= 0 or dy ~= 0 do
		if dx ~= 0 then
			inc = abs(dx) < 1 and dx or sign(dx)
			entity.x = entity.x + inc
			if (physics.checkrect(entity, grid, solidpredicate)) then
				local x
				if dx > 0 then
					x = ceil(entity.x + entity.w) - 1 - entity.w
				else
					x = floor(entity.x) + 1
				end
				dx = dx - (entity.x - x)
				entity.x = x
			else
				dx = dx - inc
			end
		end
		if dy ~= 0 then
			inc = abs(dy) < 1 and dy or sign(dy)
			entity.y = entity.y + inc
			if (physics.checkrect(entity, grid, solidpredicate)) then
				local y
				if dy > 0 then
					y = ceil(entity.y + entity.h) - 1 - entity.h
				else
					y = floor(entity.y) + 1
				end
				dy = dy - (entity.y - y)
				entity.y = y
			else
				dy = dy - inc
			end
		end
	end
end

local function inbounds(grid, x, y)
	return
		x >= 0 and y >= 0 and
		x < grid.width and y < grid.height
end

function physics.checkrect(rect, grid, predicate)
	if grid and predicate then
		x = rect.x or 0
		y = rect.y or 0
		w = rect.w or 0
		h = rect.h or 0
		local collision = false
		for i = floor(x), ceil(x + w) - 1 do
			for j = floor(y), ceil(y + h) - 1 do
				if inbounds(grid, i, j) and predicate(grid[i][j], i, j) then
					return true
				end
			end
		end
	end
end

function physics.solidpredicate(obj, x, y)
	if obj == nil then return false end
	if type(obj) == "table" then
		return not obj.nonsolid
	else
		return true
	end
end

--callback for processing raycast hits. use ... for userdata
local function raycasthitprocessor(start, dir, hit, dist, obj, hitindex, ...) end

local hit = {}
function physics.raycast(start, dir, maxdist, grid, hitprocesser, solidpredicate, ...)
	solidpredicate = solidpredicate or physics.solidpredicate
	if grid and hitprocesser then
		--TODO: finish raycast overhaul
		vec.copy(hit, start)
		local i, j = floor(hit.x), floor(hit.y)

		-- local inc = .1
		-- local dist = 0
		-- local hits = 0
		-- while dist < maxdist do
		-- 	local i = floor(hit.x)
		-- 	local j = floor(hit.y)
		-- 	if inbounds(grid, i, j) and solidpredicate(grid[i][j], i, j) then
		-- 		hitprocesser(start, dir, hit, dist, grid[i][j], hits, ...)
		-- 		hits = hits + 1
		-- 	end
		-- 	vec.copy(hit, vec.add(hit, vec.scale(dir, inc)))
		-- 	dist = dist + inc
		-- end
	end
end
