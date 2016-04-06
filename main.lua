love.graphics.setDefaultFilter("nearest", "nearest")

require "screen"
require "player"
require "color"
require "camera"
require "debug2"
require "pause"

require "Level"
require "Billboard"

local pos, skaia
function love.load(arg)
	screen.load()
	Level.setcurrent(require "level.0")
	player:load()
	billboard = Billboard("love.png")
	pos = Vector(player:center())
	pos.z = .5
end

function love.update(dt)
	if not pause.paused then
		player:update(dt)
	end
end

function screen.draw()
	love.graphics.clear()
	camera:render()
	Level.current:renderbillboards()
	render:draw()
end

function love.keypressed(key)
	return screen.keypressed(key) or pause.keypressed(key)
end

function love.mousepressed(x, y, button)
	return pause.mousepressed(x, y, button)
end
