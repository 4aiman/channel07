require "physics"
require "camera"
require "player"
require "data"

require "entity.Enemy"
require "Vector"

TV = subclass(Enemy) do

	local base = TV

	base.neighborradius = 1
	base.avoidfactor = 3
	base.damageradius = 1/4

	TV.all = data.List()

	local h = 1
	base.framesprite = Billboard("sprite/tv-frame.png", 1, 2/3, h, 1/3, h)
	base.staticsprite = Billboard("sprite/tv-static.png", 8, 2/3, h, 1/3, h, {nofog = true})
	base.smilesprite = Billboard("sprite/tv-smile.png", 8, 2/3, h, 1/3, h, {nofog = true})

	base.speed = 1

	function base:init()
		base.super.init(self, 1/4, 1/4)
		TV.all:add(self)
	end

	local avoid, dpos, temp = Vector(), Vector(), Vector()
	function base:update(dt)
		local neighborcount = 0
		avoid:set(Vector:zero())
		for i = 1, #TV.all do
			local tv = TV.all[i]
			if not tv.dead then
				local dist = temp:set(self:center()):sub(tv:center()):len()
				if dist < self.neighborradius then
					neighborcount = neighborcount + 1
					temp:scale(self.avoidfactor * (1 - (dist / self.neighborradius)))
					avoid:add(temp)
				end
			end
		end
		avoid:scale(1 / neighborcount)
		dpos:set(player:center()):sub(self:center()):norm():add(avoid):scale(self.speed * dt)
		self:move(dpos:xy())
	end

	function base:render()
		local x, y = self:center()
		local z = 0
		self.framesprite:render(x, y, z)
		local dist = camera:getscreenpoint(x, y, 0)
		if dist < 1 then
			self.smilesprite:render(x, y, z)
		else
			self.staticsprite:render(x, y, z)
		end
	end

	function base:die()
		base.super.die(self)
		TV.all:remove(self)
	end

end
