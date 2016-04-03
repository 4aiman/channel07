require "screen"
require "level"
require "player"
require "color"
require "vector"
require "camera"
require "debug2"

function love.load(arg)
	screen.load()
	level.current = require "level.0"
	player:load()
end

function love.update(dt)
	player:update(dt)
end

function screen.draw()
	love.graphics.clear()
	camera:draw()
end

-- function debug.draw()
-- 	local scale = 10
-- 	love.graphics.push()
-- 		love.graphics.scale(scale, scale)
-- 		for x = 0, level.current.width - 1 do
-- 			for y = 0, level.current.height - 1 do
-- 				local obj = level.current[x][y]
-- 				if obj then
-- 					love.graphics.push()
-- 						love.graphics.translate(x, y)
-- 						obj:draw()
-- 					love.graphics.pop()
-- 				end
-- 			end
-- 		end
-- 		player:draw()
-- 	love.graphics.pop()
-- end

function love.keypressed(key)
	screen.keypressed(key)
end
