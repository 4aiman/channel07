require "oop"
require "physics"
require "render"

require "Vector"
require "Billboard"

Level = subclass(physics.Domain) do

	local base = Level

	function	base:init(width, height)
		base.super.init(self, width, height)
	end

	local pos = Vector()
	function base:renderbillboards()
		for x = 0, self.width - 1 do
			for y = 0, self.height - 1 do
				local obj = self[x][y]
				if type(obj) == "table" and obj.class == Billboard then
					obj:render(pos:set(x + .5, y + .5, .5))
				end
			end
		end
	end

	function Level.setcurrent(level)
		Level.current = level
		physics.Domain.setcurrent(level)
	end

	function Level.load(map, key)
		if type(map) == "string" then
			map = love.image.newImageData(map)
		end
		local w, h = map:getDimensions()
		local level = Level(w, h)
		local pallete = {}
		for i, obj in ipairs(key) do
			local pixel = {map:getPixel(i - 1, 0)}
			pallete[pixel] = obj
		end
		local yoffset = math.floor(#key / w) + 1
		h = h - yoffset
		for x = 0, w - 1 do
			for y = 0, h - 1 do
				local pixel = {map:getPixel(x, y + yoffset)}
				local obj = nil
				for c, o in pairs(pallete) do
					if color.equals(pixel, c, true) then
						obj = o
						break
					end
				end
				if type(obj) == "function" then
					obj = obj(x, y)
				end
				if type(obj) == "table" then
					if not obj.nontile then
						level[x][y] = obj
					end
				else
					level[x][y] = obj
				end
			end
		end
		return level
	end

end
