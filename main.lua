love.graphics.setDefaultFilter("nearest", "nearest")

require "screen"
require "player"
require "color"
require "camera"
require "pause"

require "State"
require "Level"
require "Billboard"

function loadlevel()
	State.setcurrent(require "level.0"())
end

function love.load(arg)
	love.audio.setDistanceModel("linearclamped")
	screen.load()
	State.setcurrent(require "introcredit")
end

function love.update(dt)
	if not pause.paused then
		State.current:update(dt)
	end
end

function screen.draw()
	State.current:draw()
end

function love.keypressed(key)
	if key == "f5" then
		loadlevel()
	else
		return screen.keypressed(key) or pause.keypressed(key) or State.current:keypressed(key)
	end
end

function love.keyreleased(key)
	return State.current:keyreleased(key)
end

function love.mousepressed(x, y, button)
	return pause.mousepressed(x, y, button) or State.current:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	return State.current:mousereleased(x, y, button)
end
