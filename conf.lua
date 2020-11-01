-- Configuration
-- parsed before Love finishes initializing
function love.conf(t)
	t.title = "Life" -- The title of the window the game is in (string)
	t.version = "11.3"         -- The LÖVE version this game was made for (string)
	t.window.width = 400
	t.window.height = 240

	-- For Windows debugging
  -- comment away when releasing...
	t.console = true
end
