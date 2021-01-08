json = require "json"

local text = ""
cellsInNewGrid = 3

function love.load()
    cellSize = 5

    gridXCount = 42
    gridYCount = 48

    grid = {}
    for y = 1, gridYCount do
      grid[y] = {}
      for x = 1, gridXCount do
          grid[y][x] = false
      end
    end

    love.keyboard.setKeyRepeat(true)
end


function love.update()
    selectedX = math.floor(love.mouse.getX() / cellSize) + 1
    selectedY = math.floor(love.mouse.getY() / cellSize) + 1

    if love.mouse.isDown(1)
        and selectedX <= gridXCount
        and selectedY <= gridYCount then
        grid[selectedY][selectedX] = true
    elseif love.mouse.isDown(2) then
        grid[selectedY][selectedX] = false
    end



    if love.keyboard.isDown('backspace') then
      clear()
    end
    if love.keyboard.isDown('o') then
      exportjson()
    end
    if love.keyboard.isDown('i') then
      importjson()
    end
    if love.keyboard.isDown('p') then
      exportimage()
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'space' then
      life()
    end
end

function love.draw()
    love.graphics.print(text, 220, 40)
    for y = 1, gridYCount do
        for x = 1, gridXCount do
            local cellDrawSize = cellSize - 1

            if x == selectedX and y == selectedY then
                love.graphics.setColor(0, 1, 1)
            elseif grid[y][x] then
                love.graphics.setColor(1, 0, 1)
            else
                love.graphics.setColor(.1, .1, .1)
            end

            love.graphics.rectangle(
                'fill',
                (x - 1) * cellSize,
                (y - 1) * cellSize,
                cellDrawSize,
                cellDrawSize
            )

            --UI
            love.graphics.setColor(1, 1, 1)
            love.graphics.print('selected x: '..selectedX..', selected y: '..selectedY, 220)
            love.graphics.print('cellsInNewGrid: '..cellsInNewGrid, 220, 60)
        end
    end
end


--function love.keypressed()
function life()
    local nextGrid = {}
    for y = 1, gridYCount do
        nextGrid[y] = {}
        for x = 1, gridXCount do
            local neighbourCount = 0

            for dy = -1, 1 do
                for dx = -1, 1 do
                    if not (dy == 0 and dx == 0)
                    and grid[y + dy]
                    and grid[y + dy][x + dx] then
                        neighbourCount = neighbourCount + 1
                    end
                end
            end

            nextGrid[y][x] = neighbourCount == cellsInNewGrid or (grid[y][x] and neighbourCount == 2)
        end
    end

    grid = nextGrid
end

function clear()
  grid = {}
  for y = 1, gridYCount do
    grid[y] = {}
    for x = 1, gridXCount do
        grid[y][x] = false
    end
  end
end

function exportjson()
  f = love.filesystem.newFile("note.txt")
  f:open("w")
  f:write(json.encode(grid))
  f:close()
  text = "export json"
end

function importjson()
  f = love.filesystem.newFile("note.txt")
  f:open("r")
  content = f:read()
  grid = json.decode(content)
  f:close()
  text = "import json"
end

function exportimage()
  ImageData = love.image.newImageData(gridXCount,gridYCount)
  for y = 1, gridYCount-1 do
    for x = 1, gridXCount-1 do
      if grid[y][x] then
        ImageData:setPixel(x, y, 1, 1, 1, 1)
      else
        ImageData:setPixel(x, y, 0, 0, 0, 1)
      end
    end
  end
  filedata = ImageData:encode( "png", "lifeimage.png" )
  text = "export image"
end


function love.wheelmoved(x, y)
    if y > 0 then
        text = "Mouse wheel moved up"
        cellsInNewGrid = cellsInNewGrid+1
    elseif y < 0 then
        text = "Mouse wheel moved down"
        cellsInNewGrid = cellsInNewGrid-1
    end
end
